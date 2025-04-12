extends Control

signal shop_close

@export var anim : AnimationPlayer
@export var hooks_panel : Control

func _ready() -> void:
	pass

func _on_hooks_button_down() -> void:
	anim.play("hooks")
	pass # Replace with function body.

func _on_hooks_panel_closed() -> void:
	anim.play_backwards("hooks")
	pass # Replace with function body.

func _on_close_button_down() -> void:
	shop_close.emit()
	pass # Replace with function body.
