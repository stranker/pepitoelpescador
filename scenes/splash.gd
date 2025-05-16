extends Control

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	GameManager.load_scene("res://scenes/main_menu.tscn")
	pass # Replace with function body.
