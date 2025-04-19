class_name HookStats
extends Resource

@export var name : String
@export var id : int = -1
@export var purchased : bool = false
@export var equiped : bool = false
@export var texture : Texture
@export var level : int = 0
@export var initial_hook : bool = false

@export var price_array : Array[int]
@export var force_array : Array[float]
@export var accuracy_array : Array[float]
@export var length_array : Array[float]
@export var recover_array : Array[float]

func get_price():
	if level < price_array.size() - 1:
		return price_array[level + 1]
	else:
		return -1

func get_force():
	return force_array[level]

func get_accuracy():
	return accuracy_array[level]

func get_length():
	return length_array[level]

func get_recover():
	return length_array[level]

func reset():
	level = 0
	purchased = initial_hook
	equiped = false
	pass
