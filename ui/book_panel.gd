extends Control

@export var animation : AnimationPlayer

func _ready() -> void:
	hide()
	animation.play("show_profile")
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

func _on_shop_button_down() -> void:
	pass # Replace with function body.

func _on_map_1_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
	pass # Replace with function body.

func _on_map_2_button_down() -> void:
	pass # Replace with function body.

func _on_map_3_button_down() -> void:
	pass # Replace with function body.

func _on_close_button_button_down() -> void:
	hide()
	pass # Replace with function body.
