extends Node

var combo_counter : int = 0

signal combo_updated(combo)

func _ready() -> void:
	combo_updated.connect(GameManager.on_combo_counter_updated)

func _on_hook_no_items_collected() -> void:
	combo_counter = 0
	get_tree().call_group("ui", "on_not_items_collected")
	combo_updated.emit(combo_counter)
	pass

func _on_hook_items_collected(count: int) -> void:
	combo_counter += count
	if combo_counter > 1:
		get_tree().call_group("ui", "on_items_collected", combo_counter)
		combo_updated.emit(combo_counter)
	pass 
