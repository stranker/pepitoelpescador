extends Control

@export var animation : AnimationPlayer
@export var fishes_panel : Control

func _ready() -> void:
	hide()
	animation.play("show_profile")
	pass

func set_level_data(level_data : Level.LevelData):
	fishes_panel.set_fishes(level_data.fishes)
	pass

func _on_stats_button_down() -> void:
	animation.play("show_profile")
	pass # Replace with function body.

func _on_map_button_down() -> void:
	animation.play("show_map")
	pass # Replace with function body.

func _on_fish_button_down() -> void:
	animation.play("show_fishes")
	pass # Replace with function body.

func _on_options_button_down() -> void:
	animation.play("show_options")
	pass # Replace with function body.

func _on_close_button_button_down() -> void:
	get_tree().set_pause(false)
	hide()
	pass # Replace with function body.

func show_panel():
	show()
	get_tree().set_pause(true)
	pass
