extends Node

class GameStats:
	var gold : int = 0
	var experience : float = 0
	var player_level : int = 1
	var combo_counter : int = 0
	var days_passed : int = 0
	var day_duration : float = 20
	var fishes_catched : int = 0

var game_stats : GameStats = GameStats.new()

var debug_enabled : bool = false
var experience_increment : float = 10
var combo_counter : int = 0
var player_selected : bool = false
var level_scene : PackedScene = null
var music : AudioStreamPlayer
var character : CharacterCard = null
var game_presentation_end : bool = false

var fishes_catched : Array[Fish]

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

func _ready() -> void:
	add_to_group("gameplay")
	await get_tree().process_frame
	music = AudioStreamPlayer.new()
	add_child(music)
	music.stream = load("res://assets/music/gone_fishin_by_memoraphile_CC0.mp3")
	music.playing = true
	music.bus = "Music"
	AudioServer.set_bus_volume_db(1, -16)
	AudioServer.set_bus_volume_db(2, -16)
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
	game_stats.gold += new_gold
	gold_update.emit(game_stats.gold)
	pass

func start_level():
	fishes_catched.clear()
	get_tree().change_scene_to_packed(level_scene)
	pass

func add_experience(new_exp : float):
	game_stats.experience += new_exp
	experience_update.emit(game_stats.experience)
	if game_stats.experience >= experience_increment * game_stats.player_level:
		game_stats.experience -= experience_increment * game_stats.player_level
		experience_update.emit(game_stats.experience)
		game_stats.player_level += 1
		player_level_update.emit(game_stats.player_level)
		play_unavailable.emit()
		await get_tree().create_timer(0.7).timeout
	pass

func collect_fish(fish : Fish):
	fish_collected.emit(fish)
	add_experience(fish.fish_data.fish_experience + combo_counter)
	game_stats.fishes_catched += 1
	fishes_catched.append(fish)
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
	on_update_game_stats()
	pass

func on_upgrade_select(card):
	play_available.emit()
	pass

func on_divinity_card_selected():
	play_available.emit()
	pass

func on_character_card_selected(card):
	character = card
	player_selected = true
	on_update_game_stats()
	pass

func on_combo_counter_updated(combo_count : int):
	combo_counter = combo_count
	pass

func on_level_selected(level):
	level_scene = level.level_scene
	pass
