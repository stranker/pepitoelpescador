class_name PlayerSkin
extends Node2D

class SkinData:
	var hat_idx = 0
	var hair_idx = 0
	var face_idx = 0
	var body_idx = 0
	var skin_color : Color
	var raw_data : Dictionary
	
	func set_data(data : Dictionary):
		raw_data = data
		hat_idx = data.hat
		hair_idx = data.hair
		face_idx = data.face
		body_idx = data.body
		skin_color = Color(data.color)
		pass
	
	func update():
		raw_data = {"hat":hat_idx,"hair":hair_idx,"face":face_idx,"body":body_idx,"color":skin_color.to_html()}

@export var player_scale : float = 1
@export var face : Sprite2D
@export var hat : Sprite2D
@export var hair : Sprite2D
@export var body : Sprite2D

var data : SkinData = SkinData.new()

signal update_skin_data(data)

func _ready() -> void:
	if GameManager.skin_data:
		_set_skin_data(GameManager.skin_data)
	else:
		update_skin_data.connect(GameManager.on_update_skin_data)
	pass

func next_hat():
	next_frame_sprite(hat)
	pass

func next_hair():
	next_frame_sprite(hair)
	pass

func next_face():
	next_frame_sprite(face)
	pass

func next_body():
	next_frame_sprite(body)
	pass

func previous_hat():
	previous_frame_sprite(hat)
	pass

func previous_hair():
	previous_frame_sprite(hair)
	pass

func previous_face():
	previous_frame_sprite(face)
	pass

func previous_body():
	previous_frame_sprite(body)
	pass

func previous_frame_sprite(sprite : Sprite2D):
	sprite.frame = sprite.hframes - 1 if sprite.frame <= 0 else sprite.frame - 1
	_update_data()
	pass

func next_frame_sprite(sprite : Sprite2D):
	sprite.frame = 0 if sprite.frame >= sprite.hframes - 1 else sprite.frame + 1
	_update_data()
	pass

func randomize():
	hat.frame = randi() % hat.hframes
	hair.frame = randi() % hair.hframes
	face.frame = randi() % face.hframes
	body.frame = randi() % body.hframes
	_update_data()
	pass

func set_skin_color(color : Color):
	data.skin_color = color
	$Scale/BackBody.self_modulate = color
	$Scale/BackBody/Hands.self_modulate = color
	pass

func _update_data():
	data.hat_idx = hat.frame
	data.hair_idx = hair.frame
	data.face_idx = face.frame
	data.body_idx = body.frame
	data.update()
	update_skin_data.emit(data)
	pass

func _set_skin_data(new_data : SkinData):
	data = new_data
	hat.frame = data.hat_idx
	hair.frame = data.hair_idx
	face.frame = data.face_idx
	body.frame = data.body_idx
	set_skin_color(data.skin_color)
	pass
