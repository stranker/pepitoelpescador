extends Node

class GameStats:
	
	signal fishes_updated()
	
	var gold : int = 0
	var experience : float = 0
	var player_level : int = 1
	var days_passed : int = 0
	var day_duration : float = 40
	var total_fishes_catched : int = 0
	var fishes_data : Dictionary = {}
	
	func reset():
		gold = 0
		experience = 0
		player_level = 1
		days_passed =  0
		day_duration = 0
		total_fishes_catched = 0
		fishes_data.clear()
		pass
	
	func update_fish(fish : Fish):
		total_fishes_catched += 1
		fish.fish_data.update(fish)
		fishes_updated.emit()
		fishes_data[str(fish.fish_id)] = {
			"count": fish.fish_data.count,
			"unlocked": fish.fish_data.unlocked,
			"unlock_showed": fish.fish_data.unlock_showed,
			"max_weight": fish.fish_data.max_weight,
			"fish_stars": fish.fish_stars
		}
		pass
	
	func update_fish_data(fish_data : FishData):
		fishes_data[str(fish_data.id)] = {
			"count": fish_data.count,
			"unlocked": fish_data.unlocked,
			"unlock_showed": fish_data.unlock_showed,
			"max_weight": fish_data.max_weight,
			"fish_stars": fish_data.fish_stars
		}
		pass

var game_stats : GameStats = GameStats.new()

const game_data_path : String = "user://save_game.dat"

var debug_enabled : bool = false
var experience_increment : float = 10
var combo_counter : int = 0
var player_selected : bool = false
var music : AudioStreamPlayer
var game_presentation_end : bool = false
var skin_data : PlayerSkin.SkinData = null
var gold_increment : float = 0

var map_selected : MapData
var fishes_catched : Array[Fish]

var maps : Array[MapData]

signal gold_update(gold)
signal experience_update(exp)
signal player_level_update(level)
signal fish_collected(fish)
signal play_available()
signal play_unavailable()
signal day_time_start(day_duration)
signal divinity_day()
signal update_game_stats(stats)
signal end_day(fishes)

@onready var loading_scene : PackedScene = preload("res://scenes/loading_screen.tscn")

func _ready() -> void:
	add_to_group("gameplay")
	_load_game_data()
	await get_tree().process_frame
	_create_music()
	game_stats.fishes_updated.connect(on_fishes_updated)
	pass

func on_fishes_updated():
	pass

func load_scene(scene_path : String):
	var loading : LoadingScene = loading_scene.instantiate()
	loading.scene_loaded.connect(on_game_scene_loaded)
	get_tree().root.add_child(loading)
	loading.load(scene_path)
	pass

func on_game_scene_loaded(scene_path : String):
	var game_scene = ResourceLoader.load_threaded_get(scene_path)
	get_tree().change_scene_to_packed(game_scene)
	pass

func _load_game_data():
	if FileAccess.file_exists(game_data_path):
		var data : Dictionary = load_from_file()
		game_stats.gold = data.gold
		game_stats.experience = data.experience
		game_stats.player_level = data.player_level
		game_stats.days_passed = data.days_passed
		game_stats.total_fishes_catched = data.total_fishes_catched
		game_stats.fishes_data = data.fishes_data
		_update_data_manager(data)
		ItemManager.set_loaded_items(data.items)
		ItemManager.set_loaded_boat(data.boat_tier)
		CardManager.set_character(data.player_card_type)
		skin_data = PlayerSkin.SkinData.new()
		skin_data.set_data(data.player_skin)
		player_selected = true
	pass

func save_game_data():
	var game_data : Dictionary = {
		"gold" = game_stats.gold,
		"experience" = game_stats.experience,
		"player_level" = game_stats.player_level,
		"days_passed" = game_stats.days_passed,
		"fishes_data" = game_stats.fishes_data,
		"total_fishes_catched" = game_stats.total_fishes_catched,
		"items" = ItemManager.get_items_for_save(),
		"boat_tier" = ItemManager.get_boat_data(),
		"player_card_type" = CardManager.get_character_card_for_save(),
		"player_skin" = skin_data.raw_data,
		"quests_data" = QuestManager.get_quest_for_save()
	}
	_update_data_manager()
	save_to_file(game_data)
	pass

func _update_data_manager(data : Dictionary = {}):
	if not data.is_empty():
		DataManager.update_quests(data.quests_data)
	print_debug(game_stats.fishes_data)
	DataManager.update_fishes_data(game_stats.fishes_data)
	pass

func save_to_file(content : Dictionary):
	var file = FileAccess.open(game_data_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(content))
	pass

func load_from_file():
	var file = FileAccess.open(game_data_path, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func _create_music():
	music = AudioStreamPlayer.new()
	add_child(music)
	music.stream = load("res://assets/music/gone_fishin_by_memoraphile_CC0.mp3")
	music.playing = true
	music.bus = "Music"
	pass

func on_midnight_end():
	end_day.emit(fishes_catched)
	pass

func on_end_boss_presentation():
	_start_game()
	pass

func _start_game():
	day_time_start.emit(game_stats.day_duration)
	pass

func add_gold(new_gold : int):
	var tween : Tween = create_tween()
	tween.tween_method(_on_coin_tween, game_stats.gold, game_stats.gold + new_gold, 1)
	tween.play()
	await tween.finished
	game_stats.gold += new_gold
	save_game_data()
	pass

func _on_coin_tween(gold):
	gold_update.emit(gold)
	pass

func spend_coins(gold : int):
	game_stats.gold -= gold
	gold_update.emit(game_stats.gold)
	pass

func start_level():
	game_stats.days_passed += 1
	gold_increment = 0
	fishes_catched.clear()
	load_scene(map_selected.scene.resource_path)
	pass

func add_experience(new_exp : float):
	game_stats.experience += new_exp
	experience_update.emit(game_stats.experience)
	if game_stats.experience >= experience_increment * game_stats.player_level:
		game_stats.experience -= experience_increment * game_stats.player_level
		experience_update.emit(game_stats.experience)
		game_stats.player_level += 1
		player_level_update.emit(game_stats.player_level)
		#play_unavailable.emit()
		await get_tree().create_timer(0.7).timeout
	pass

func collect_fish(fish : Fish):
	add_experience(fish.fish_data.fish_experience + combo_counter)
	game_stats.update_fish(fish)
	fishes_catched.append(fish)
	fish_collected.emit(fish)
	on_update_game_stats()
	pass

func on_ui_play_available():
	play_available.emit()
	pass

func on_ui_play_unavailable():
	play_unavailable.emit()
	pass

func on_update_game_stats():
	update_game_stats.emit(game_stats)
	pass

func on_end_of_day():
	game_stats.days_passed += 1
	gold_increment = 0
	on_update_game_stats()
	pass

func on_upgrade_select(card):
	play_available.emit()
	pass

func on_divinity_card_selected():
	play_available.emit()
	pass

func on_character_card_selected(card):
	player_selected = true
	on_update_game_stats()
	pass

func on_combo_counter_updated(combo_count : int):
	combo_counter = combo_count
	pass

func on_level_selected(map):
	map_selected = map
	pass

func clear_saved_data():
	game_stats.reset()
	player_selected = false
	skin_data = null
	DataManager.reset()
	ItemManager.reset()
	CardManager.reset()
	pass

func on_update_skin_data(data : PlayerSkin.SkinData):
	skin_data = data
	pass

func stop_frames(count : int):
	Engine.time_scale = 0
	for i in range(count):
		await get_tree().process_frame
	Engine.time_scale = 1
	pass

func update_fish_data(fish_data : FishData):
	game_stats.update_fish_data(fish_data)
	pass

func on_quest_claimed(quest_data : QuestData):
	#COINS, EXP, ITEM 
	var quest_reward : QuestReward = quest_data.get_current_reward()
	match quest_reward.type:
		QuestReward.RewardType.COINS:
			add_gold(quest_reward.data)
	pass
