extends Control

@export var anim : AnimationPlayer

@export var head : TextureRect
@export var hat : TextureRect
@export var body : TextureRect

@export var head_textures : Array[Texture]
@export var hat_textures : Array[Texture]
@export var body_textures : Array[Texture]

var head_idx : int = 0
var hat_idx : int = 0
var body_idx : int = 0

func _update_hat_texture():
	hat_idx = hat_idx % hat_textures.size()
	hat.texture = hat_textures[hat_idx]
	pass

func _update_head_texture():
	head_idx = head_idx % head_textures.size()
	head.texture = head_textures[head_idx]
	pass

func _update_body_texture():
	body_idx = body_idx % body_textures.size()
	body.texture = body_textures[body_idx]
	pass

func _on_hat_left_button_down() -> void:
	hat_idx -= 1
	_update_hat_texture()
	pass

func _on_face_left_button_down() -> void:
	head_idx -= 1
	_update_head_texture()
	pass

func _on_body_left_button_down() -> void:
	body_idx -= 1
	_update_body_texture()
	pass

func _on_hat_right_button_down() -> void:
	hat_idx += 1
	_update_hat_texture()
	pass

func _on_face_right_button_down() -> void:
	head_idx += 1
	_update_head_texture()
	pass

func _on_body_right_button_down() -> void:
	body_idx += 1
	_update_body_texture()
	pass

func _on_randomize_button_down() -> void:
	head_idx = randi() % head_textures.size()
	hat_idx = randi() % hat_textures.size()
	body_idx = randi() % body_textures.size()
	_update_head_texture()
	_update_hat_texture()
	_update_body_texture()
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
