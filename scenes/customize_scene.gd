extends Control

@export var anim : AnimationPlayer
@export var skin_colors : HBoxContainer

@export var face : Sprite2D
@export var hat : Sprite2D
@export var body : Sprite2D

@export var player_skin : Array[Sprite2D]

func _ready() -> void:
	_bind_skin_buttons()
	on_skin_color_changed(skin_colors.get_child(0).get_theme_stylebox("normal").bg_color)
	pass

func _bind_skin_buttons():
	for skin_button in skin_colors.get_children():
		var button : Button = skin_button as Button
		var style_box : StyleBoxFlat = button.get_theme_stylebox("normal")
		var skin_color : Color = style_box.bg_color
		button.pressed.connect(on_skin_color_changed.bind(skin_color))
	pass

func on_skin_color_changed(skin_color : Color):
	for part in player_skin:
		part.self_modulate = skin_color
	pass

func _on_hat_left_button_down() -> void:
	previous_frame_sprite(hat)
	pass

func _on_face_left_button_down() -> void:
	previous_frame_sprite(face)
	pass

func _on_body_left_button_down() -> void:
	previous_frame_sprite(body)
	pass

func _on_hat_right_button_down() -> void:
	next_frame_sprite(hat)
	pass

func _on_face_right_button_down() -> void:
	next_frame_sprite(face)
	pass

func _on_body_right_button_down() -> void:
	next_frame_sprite(body)
	pass

func previous_frame_sprite(sprite : Sprite2D):
	sprite.frame = sprite.hframes - 1 if sprite.frame <= 0 else sprite.frame - 1
	pass

func next_frame_sprite(sprite : Sprite2D):
	sprite.frame = 0 if sprite.frame >= sprite.hframes - 1 else sprite.frame + 1
	pass

func _on_randomize_button_down() -> void:
	face.frame = randi() % face.hframes
	hat.frame = randi() % hat.hframes
	body.frame = randi() % body.hframes
	pass

func _on_confirm_button_down() -> void:
	anim.play("confirm_customize")
	pass

func _on_card_selector_back() -> void:
	anim.play("idle")
	pass # Replace with function body.

func _on_card_selector_character_card_selected(character: Variant) -> void:
	GameManager.load_scene("res://scenes/main_scene.tscn")
	pass # Replace with function body.
