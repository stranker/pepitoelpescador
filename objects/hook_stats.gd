class_name HookStats
extends Resource

@export var name : String
@export var id : int = -1
@export var purchased : bool = false
@export var equiped : bool = false
@export var texture : Texture
@export var level : int = 0
@export var initial_hook : bool = false
@export var penetration : int = 1

@export var price_array : Array[int]
@export var force_array : Array[float]
@export var accuracy_array : Array[float]
@export var length_array : Array[float]
@export var recover_array : Array[float]

const MAX_ACCURACY = 5

func set_max_penetration(value : int):
	penetration = value
	pass

func get_next_price():
	if level < get_max_level() - 1:
		return price_array[level + 1]
	else:
		return -1

func get_price():
	return price_array[level]

func purchase():
	purchased = true
	pass

func get_force():
	return force_array[level]

func get_accuracy():
	return accuracy_array[level]

func get_length():
	return length_array[level]

func get_recover():
	return recover_array[level]

func get_next_force():
	if level + 1 >= get_max_level():
		return force_array.back()
	return force_array[level + 1]

func get_next_accuracy():
	if level + 1 >= get_max_level():
		return accuracy_array.back()
	return accuracy_array[level + 1]

func get_next_length():
	if level + 1 >= get_max_level():
		return length_array.back()
	return length_array[level + 1]

func get_next_recover():
	if level + 1 >= get_max_level():
		return recover_array.back()
	return recover_array[level + 1]

func reset():
	level = 0
	purchased = initial_hook
	equiped = initial_hook
	pass

func upgrade():
	level += 1
	pass

func get_max_level():
	return price_array.size()

func can_upgrade():
	return level < get_max_level()

func is_max_level():
	return level + 1 >= get_max_level()

func unequip():
	equiped = false
	pass

func equip():
	equiped = true
	pass

func load_save_data(data : Dictionary):
	id = int(data.id)
	purchased = data.purchased
	equiped = data.equiped
	level = data.level
	pass

func get_save_data():
	var data : Dictionary = {
		"id":str(id),
		"purchased":purchased,
		"equiped":equiped,
		"level":level,
	}
	return data
