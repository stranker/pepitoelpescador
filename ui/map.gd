extends Control

@export var maps_container : Control

signal map_close
signal level_selected(map)

func _ready() -> void:
	for map in maps_container.get_children():
		map.select.connect(on_map_selected.bind(map))
	level_selected.connect(GameManager.on_level_selected)
	ItemManager.boat_upgraded.connect(on_boat_upgraded)
	maps_container.get_child(0).select_map()
	pass

func on_boat_upgraded(boat : BoatData):
	for i in range(boat.current_tier + 1):
		maps_container.get_child(i).unlock()
	pass

func on_map_selected(selected_map):
	for map in maps_container.get_children():
		map.set_selected(selected_map == map)
	level_selected.emit(selected_map)
	pass

func _on_continue_button_down() -> void:
	GameManager.start_level()
	pass # Replace with function body.


func _on_close_button_button_down() -> void:
	map_close.emit()
	pass # Replace with function body.
