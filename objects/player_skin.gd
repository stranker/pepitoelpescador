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

func set_hat(idx : int):
	hat.frame = idx
	pass

func set_hair(idx : int):
	hair.frame = idx
	pass

func set_face(idx : int):
	face.frame = idx
	pass

func set_body(idx : int):
	body.frame = idx
	pass

func randomize_skin():
	var rng = RandomNumberGenerator.new()
	hat.frame = rng.randi_range(0, hat.hframes - 1)
	print_debug(hat.frame)
	hair.frame = rng.randi_range(0, hair.hframes - 1)
	print_debug(hair.frame)
	rng.randomize()
	face.frame = rng.randi_range(0, face.hframes - 1)
	print_debug(face.frame)
	rng.randomize()
	body.frame = rng.randi_range(0, body.hframes - 1)
	print_debug(body.frame)
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

func save():
	_update_data()
	pass
