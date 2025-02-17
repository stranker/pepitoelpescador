extends Node

var debug_enabled : bool = false
var gold : int = 0
var experience : float = 0
var experience_increment : float = 10
var player_level : int = 1
var combo_counter : int = 0
var days_passed : int = 0
var day_duration : float = 10
var player_selected : bool = false

signal gold_update(gold)
signal experience_update(exp)
signal player_level_update(level)
signal fish_collected(fish, data)
signal play_available()
signal play_unavailable()
signal day_time_start(day_duration)
signal divinity_day()

func _ready() -> void:
	await get_tree().process_frame
	pass

func on_midnight_start():
	print_debug("MIDNIGHT START")
	pass

func on_midnight_end():
	print_debug("MIDNIGHT END")
	pass

func on_end_boss_presentation():
	_start_game()
	pass

func _start_game():
	day_time_start.emit(day_duration)
	pass

func on_upgrade_selected(_upgrade):
	#resume_experience_gained()
	pass

func add_gold(new_gold : int):
	gold += new_gold
	gold_update.emit(gold)
	pass

func add_experience(new_exp : float):
	experience += new_exp
	experience_update.emit(experience)
	if experience >= experience_increment * player_level:
		experience -= experience_increment * player_level
		experience_update.emit(experience)
		player_level += 1
		player_level_update.emit(player_level)
		play_unavailable.emit()
		await get_tree().create_timer(0.7).timeout
	pass

func resume_experience_gained():
	experience -= experience_increment * player_level - 1
	experience_update.emit(experience)
	pass

func collect_fish(fish : Fish,):
	fish_collected.emit(fish)
	add_experience(fish.fish_data.fish_experience + combo_counter)
	pass

func on_ui_play_available():
	play_available.emit()
	pass

func on_ui_play_unavailable():
	play_unavailable.emit()
	pass

func on_end_of_day():
	#end_of_day.emit()
	days_passed += 1
	#_check_divinity_day()
	pass

func _check_divinity_day():
	if days_passed % 5 == 0 and days_passed != 0:
		divinity_day.emit()
		play_unavailable.emit()
	pass

func on_end_upgrade_select():
	play_available.emit()
	pass

func on_divinity_card_selected():
	play_available.emit()
	pass

func on_character_card_selected():
	player_selected = true
	play_available.emit()
	pass

func on_combo_counter_updated(combo_count : int):
	combo_counter = combo_count
	pass
