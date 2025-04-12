extends Node2D

@export var cinematic_camera : Camera2D

@export var anim : AnimationPlayer

var enabled_input : bool = false

func _ready() -> void:
	if GameManager.game_presentation_end:
		cinematic_camera.global_position = get_viewport_rect().size * 0.5
		enabled_input = true
		return
	pass

func init_cinematic():
	var tween : Tween = create_tween()
	tween.tween_property(cinematic_camera, "position", get_viewport_rect().size * 0.5, 2).set_ease(Tween.EASE_IN)
	tween.play()
	await tween.finished
	enabled_input = true
	GameManager.game_presentation_end = true
	pass

func _on_fisherman_hut_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not enabled_input: return
	if event is InputEventScreenTouch:
		anim.play("fisherman_hut")
	pass # Replace with function body.


func _on_travel_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not enabled_input: return
	if event is InputEventScreenTouch:
		anim.play("map")
	pass # Replace with function body.

func _on_shop_shop_close() -> void:
	anim.play("idle")
	pass # Replace with function body.

func _on_map_map_close() -> void:
	anim.play("idle")
	pass # Replace with function body.

func _on_boat_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not enabled_input: return
	if event is InputEventScreenTouch:
		anim.play("map")
	pass # Replace with function body.


func _on_card_selector_character_card_selected(character: Variant) -> void:
	if GameManager.game_presentation_end:
		cinematic_camera.global_position = get_viewport_rect().size * 0.5
		enabled_input = true
		return
	init_cinematic()
	pass # Replace with function body.


func _on_shop_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not enabled_input: return
	if event is InputEventScreenTouch:
		anim.play("shop")
	pass # Replace with function body.
