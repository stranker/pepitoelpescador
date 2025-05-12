extends Control

@export var anim : AnimationPlayer
@export var skin_colors : HBoxContainer

@export var player_skin : PlayerSkin

func _ready() -> void:
	_bind_skin_buttons()
	var skin_color = skin_colors.get_child(0).get_theme_stylebox("normal").bg_color
	on_skin_color_changed(skin_color)
	player_skin.set_skin_color(skin_color)
	pass

func _bind_skin_buttons():
	for skin_button in skin_colors.get_children():
		var button : Button = skin_button as Button
		var style_box : StyleBoxFlat = button.get_theme_stylebox("normal")
		var skin_color : Color = style_box.bg_color
		button.pressed.connect(on_skin_color_changed.bind(skin_color))
	pass

func on_skin_color_changed(skin_color : Color):
	player_skin.set_skin_color(skin_color)
	pass

func _on_hat_left_button_down() -> void:
	player_skin.previous_hat()
	pass

func _on_face_left_button_down() -> void:
	player_skin.previous_face()
	pass

func _on_body_left_button_down() -> void:
	player_skin.previous_body()
	pass

func _on_hat_right_button_down() -> void:
	player_skin.next_hat()
	pass

func _on_face_right_button_down() -> void:
	player_skin.next_face()
	pass

func _on_body_right_button_down() -> void:
	player_skin.next_body()
	pass

func _on_randomize_button_down() -> void:
	player_skin.randomize()
	var random_button = skin_colors.get_children().pick_random()
	var skin_color = random_button.get_theme_stylebox("normal").bg_color
	on_skin_color_changed(skin_color)
	random_button.button_pressed = true
	pass

func _on_confirm_button_down() -> void:
	player_skin.save()
	anim.play("confirm_customize")
	pass

func _on_card_selector_back() -> void:
	anim.play("idle")
	pass # Replace with function body.

func _on_card_selector_character_card_selected(character: Variant) -> void:
	GameManager.load_scene("res://scenes/main_scene.tscn")
	pass # Replace with function body.


func _on_hair_left_button_down() -> void:
	player_skin.previous_hair()
	pass # Replace with function body.


func _on_hair_right_button_down() -> void:
	player_skin.next_hair()
	pass # Replace with function body.
