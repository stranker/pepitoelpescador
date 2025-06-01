extends Control

@export var anim : AnimationPlayer
@export var skin_colors : HBoxContainer

@export var hat_slider : HSlider
@export var hair_slider : HSlider
@export var face_slider : HSlider
@export var body_slider : HSlider

@export var player_skin : PlayerSkin

func _ready() -> void:
	_bind_skin_buttons()
	var skin_color = skin_colors.get_child(0).get_theme_stylebox("normal").bg_color
	on_skin_color_changed(skin_color)
	player_skin.set_skin_color(skin_color)
	_update_sliders()
	pass

func _update_sliders():
	hat_slider.max_value = player_skin.hat.hframes - 1
	hair_slider.max_value = player_skin.hair.hframes - 1
	face_slider.max_value = player_skin.face.hframes - 1
	body_slider.max_value = player_skin.body.hframes - 1
	
	hat_slider.tick_count = player_skin.hat.hframes
	hair_slider.tick_count = player_skin.hair.hframes
	face_slider.tick_count = player_skin.face.hframes 
	body_slider.tick_count = player_skin.body.hframes
	
	hat_slider.value = player_skin.hat.frame
	hair_slider.value = player_skin.hair.frame
	face_slider.value = player_skin.face.frame
	body_slider.value = player_skin.body.frame
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

func _on_randomize_button_down() -> void:
	AudioManager.play_button_sound()
	player_skin.randomize_skin()
	_update_sliders()
	var random_button = skin_colors.get_children().pick_random()
	var skin_color = random_button.get_theme_stylebox("normal").bg_color
	on_skin_color_changed(skin_color)
	random_button.button_pressed = true
	pass

func _on_confirm_button_down() -> void:
	AudioManager.play_button_sound()
	player_skin.save()
	anim.play("confirm_customize")
	pass

func _on_card_selector_back() -> void:
	anim.play("idle")
	pass # Replace with function body.

func _on_card_selector_character_card_selected(character: Variant) -> void:
	GameManager.load_scene("res://scenes/main_scene.tscn")
	pass # Replace with function body.


func _on_hat_slider_value_changed(value: float) -> void:
	player_skin.set_hat(int(value))
	pass # Replace with function body.


func _on_hair_slider_value_changed(value: float) -> void:
	player_skin.set_hair(int(value))
	pass # Replace with function body.


func _on_face_slider_value_changed(value: float) -> void:
	player_skin.set_face(int(value))
	pass # Replace with function body.


func _on_body_slider_value_changed(value: float) -> void:
	player_skin.set_body(int(value))
	pass # Replace with function body.
