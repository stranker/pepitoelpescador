class_name Level
extends Node2D

class LevelData:
	var level_name : String = ""
	var fishes : Array[FishData]

@export var fishes : Array[FishData]

var level_data : LevelData = LevelData.new()

@export var cinematic_camera : Camera2D
@export var boss_fish : Fish

signal update_level_data(level_data)
signal afternoon
signal midnight_end

func _ready() -> void:
	add_to_group("Level")
	cinematic_camera.set_end_boss(boss_fish)
	GameManager.fish_collected.connect(on_fish_collected)
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

func on_afternoon_start():
	afternoon.emit()
	pass

func on_midnight_end():
	midnight_end.emit()
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_add_experience"):
		GameManager.add_experience(5)
