extends Control

@export var results : VBoxContainer
@export var anim : AnimationPlayer
@export var total_result : Control
@export var no_fish_label : Label

const result_item_scene : PackedScene = preload("res://ui/result_item.tscn")

var fishes_data: Dictionary = {}

var input_enabled : bool = false
var total_gold : int = 0
var total_count : int = 0
var size_max : float = 0

func _ready() -> void:
	GameManager.end_day.connect(on_end_day)
	GameManager.fish_collected.connect(on_fish_collected)
	pass

func on_end_day(fishes):
	anim.play("show")
	pass

func on_fish_collected(fish : Fish):
	var fish_name : String = fish.fish_data.fish_name
	total_gold += fish.fish_data.fish_gold
	total_count += 1
	if fish.fish_size > size_max:
		size_max = fish.fish_size
	if not fishes_data.has(fish_name):
		fishes_data[fish_name] = {"name":fish_name, "texture": fish.fish_data.fish_texture,"count": 1, "size": fish.fish_size, "gold": fish.fish_data.fish_gold}
		var result_item = result_item_scene.instantiate()
		results.add_child(result_item)
		result_item.set_data(fishes_data[fish_name])
	else:
		fishes_data[fish_name].count += 1
		fishes_data[fish_name].gold += fish.fish_data.fish_gold
		if fishes_data[fish_name].size < fish.fish_size:
			fishes_data[fish_name].size = fish.fish_size
		for result_item in results.get_children():
			if result_item.fish_name == fish_name:
				result_item.set_data(fishes_data[fish_name])
				break
	_update_total()
	pass

func _update_total():
	no_fish_label.visible = total_count <= 0
	total_result.set_data({"count":total_count,"gold":total_gold,"size":size_max})
	pass

func _input(event: InputEvent) -> void:
	if not input_enabled: return
	if event is InputEventScreenTouch:
		anim.play_backwards("show")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show":
		if not input_enabled:
			input_enabled = true
		else:
			get_tree().change_scene_to_file("res://scenes/main_scene.tscn")
	pass # Replace with function body.
