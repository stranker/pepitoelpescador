class_name Level
extends Node2D

class LevelData:
	var level_name : String = ""
	var fishes : Array[FishData]

@export var fishes : Array[FishData]

var level_data : LevelData = LevelData.new()

signal update_level_data(level_data)

func _ready() -> void:
	GameManager.fish_collected.connect(on_fish_collected)
	add_to_group("Level")
	level_data.fishes = fishes
	await get_tree().process_frame
	update_level_data.emit(level_data)
	pass

func on_fish_collected(fish : Fish):
	for level_fish in level_data.fishes:
		if level_fish.fish_name == fish.fish_data.fish_name:
			if not level_fish.unlocked:
				level_fish.unlocked = true
			break
	update_level_data.emit(level_data)
	pass
