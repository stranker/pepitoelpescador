extends Control

@export var maps_container : Control
@export var anim : AnimationPlayer
@export var map_info : Control

enum State { IDLE, MAP_SELECTED, MAP_FISHES }

signal map_close
signal level_selected(map)

var current_state : State = State.IDLE

func _ready() -> void:
	for i in range(DataManager.maps.size()):
		var map_data : MapData = DataManager.maps[i]
		var map_item = maps_container.get_child(i)
		map_item.select.connect(on_map_selected)
		map_item.set_data(map_data)
	level_selected.connect(GameManager.on_level_selected)
	ItemManager.boat_upgraded.connect(on_boat_upgraded)
	pass

func on_boat_upgraded(boat : BoatData):
	for i in range(boat.current_tier + 1):
		maps_container.get_child(i).unlock()
	pass

func on_map_selected(selected_map : MapData):
	anim.play("map_selected")
	current_state = State.MAP_SELECTED
	_update_map_info(selected_map)
	level_selected.emit(selected_map)
	pass

func _update_map_info(map_data : MapData):
	map_info.set_data(map_data)
	pass

func _on_close_button_button_down() -> void:
	_check_close()
	pass # Replace with function body.

func _check_close():
	match current_state:
		State.IDLE:
			map_close.emit()
		State.MAP_SELECTED:
			anim.play("idle")
			current_state = State.IDLE
	pass

func _on_map_info_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_check_close()
	pass # Replace with function body.

func _on_map_info_closed() -> void:
	anim.play("idle")
	current_state = State.IDLE
	pass # Replace with function body.
