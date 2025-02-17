extends Node2D

signal afternoon
signal midnight_start
signal midnight_end

func on_midnight_start():
	midnight_start.emit()
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
