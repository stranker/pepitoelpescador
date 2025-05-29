extends Control

@export var results_parent : VBoxContainer
@export var anim : AnimationPlayer
@export var total_result : Control
@export var no_fish_label : Label

const result_item_scene : PackedScene = preload("res://ui/result_item.tscn")

var result_items : Array[Utils.ResultItemData] = []
var total_result_data : Utils.ResultItemData = Utils.ResultItemData.new()

var input_enabled : bool = false

func _ready() -> void:
	GameManager.end_day.connect(on_end_day)
	GameManager.fish_collected.connect(on_fish_collected)
	pass

func on_end_day(fishes : Array):
	_create_results()
	anim.play("show")
	if fishes.is_empty():
		anim.queue("show_no_fishes")
	else:
		anim.queue("show_fishes")
	pass

func on_fish_collected(fish : Fish):
	var result_item : Utils.ResultItemData = _get_result_item_data(fish)
	if result_item:
		result_item.update(fish)
	else:
		result_item = Utils.ResultItemData.new()
		result_item.init(fish)
		result_items.append(result_item)
	if total_result_data:
		total_result_data.update(fish)
	else:
		total_result_data.init(fish)
	_create_results()
	pass

func _create_results():
	for child in results_parent.get_children():
		child.queue_free()
	for result_item in result_items:
		var result_ui = result_item_scene.instantiate()
		results_parent.add_child(result_ui)
		result_ui.set_data(result_item)
	total_result.set_data(total_result_data)
	pass

func _get_result_item_data(fish : Fish):
	for result_item in result_items:
		if result_item.id == fish.fish_id:
			return result_item
	return null

func end_presentation():
	if input_enabled: return
	input_enabled = true
	GameManager.add_gold(total_result_data.gold + total_result_data.increment)
	GameManager.save_game_data()
	pass

func continue_to_main():
	GameManager.load_scene("res://scenes/main_scene.tscn")
	pass

func _on_gui_input(event: InputEvent) -> void:
	if not input_enabled: return
	if event is InputEventScreenTouch:
		anim.play("end")
	pass # Replace with function body.
