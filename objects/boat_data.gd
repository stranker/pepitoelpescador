class_name BoatData
extends Resource

@export var price_list : Array[int]
@export var day_time_values : Array[float]
@export var current_tier : int = 0

func get_max_tier():
	return price_list.size()

func next_price():
	var next_tier = current_tier + 1
	if next_tier < price_list.size():
		return price_list[next_tier]
	else:
		return -1

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
