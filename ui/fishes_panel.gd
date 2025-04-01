extends Control

@export var fishes_grid : GridContainer
@export var fish_panel_item_scene : PackedScene

func set_fishes(fishes : Array[FishData]):
	if fishes_grid.get_children().is_empty():
		for fish in fishes:
			var fish_panel_item = fish_panel_item_scene.instantiate()
			fishes_grid.add_child(fish_panel_item)
			fish_panel_item.set_data(fish)
	else:
		for i in range(fishes_grid.get_child_count()):
			fishes_grid.get_child(i).set_data(fishes[i])
	pass


func _on_visibility_changed() -> void:
	if visible:
		for fish_item in fishes_grid.get_children():
			fish_item.update()
	pass # Replace with function body.
