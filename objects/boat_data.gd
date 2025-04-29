class_name BoatData
extends Resource

@export var price_list : Array[int]
@export var day_time_values : Array[float]
@export var textures : Array[Texture]
@export var current_tier : int = 0

func get_day_time():
	return day_time_values[current_tier]

func get_next_day_time():
	if current_tier + 1 >= get_max_tier():
		return day_time_values.back()
	return day_time_values[current_tier + 1]

func get_max_tier():
	return price_list.size()

func next_price():
	var next_tier = current_tier + 1
	if next_tier < price_list.size():
		return price_list[next_tier]
	else:
		return -1

func get_texture():
	return textures[current_tier]

func upgrade():
	current_tier += 1
	pass

func set_tier(tier):
	current_tier = tier
	pass

func reset():
	current_tier = 0
	GameManager.game_stats.day_duration = day_time_values[current_tier]
	pass
