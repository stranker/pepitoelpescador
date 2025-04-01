extends Control

@export var name_label : Label
@export var texture_rect : TextureRect
@export var anim : AnimationPlayer

var show_first_catch : bool = true

var fish : FishData

func set_data(fish_data : FishData):
	fish = fish_data
	name_label.text = fish_data.fish_name
	texture_rect.texture = fish_data.fish_texture
	pass

func update():
	if fish.unlocked:
		if show_first_catch:
			show_first_catch = false
			anim.play("first_catch")
		else:
			anim.play("unlocked")
	pass
