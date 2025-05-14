extends Control

@export var anim: AnimationPlayer

signal closed

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		closed.emit()
	pass # Replace with function body.

func show_credits():
	anim.play("show")
	pass
