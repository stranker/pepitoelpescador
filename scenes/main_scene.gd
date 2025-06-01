extends Control

@export var cinematic_camera : Camera2D

@export var anim : AnimationPlayer

var enabled_input : bool = false

func _ready() -> void:
	GameManager.save_game_data()
	if GameManager.game_presentation_end:
		cinematic_camera.global_position = get_viewport_rect().size * 0.5
		anim.play("presentation")
		return
	else:
		init_cinematic()
	pass

func init_cinematic():
	var tween : Tween = create_tween()
	tween.tween_property(cinematic_camera, "position", get_viewport_rect().size * 0.5, 2).set_ease(Tween.EASE_IN)
	tween.play()
	await tween.finished
	GameManager.game_presentation_end = true
	anim.play("presentation")
	pass

func _on_shop_shop_close() -> void:
	anim.play("idle")
	pass # Replace with function body.

func _on_map_map_close() -> void:
	anim.play("idle")
	pass # Replace with function body.

func _on_options_button_down() -> void:
	anim.play("options")
	pass # Replace with function body.

func _on_options_panel_closed() -> void:
	anim.play("idle")
	pass # Replace with function body.

func enable_inputs():
	enabled_input = true
	pass

func _on_house_gui_input(event: InputEvent) -> void:
	if not enabled_input: return
	if event is InputEventScreenTouch:
		anim.play("shop")
	pass # Replace with function body.


func _on_boat_gui_input(event: InputEvent) -> void:
	if not enabled_input: return
	if event is InputEventScreenTouch:
		anim.play("map")
	pass # Replace with function body.
