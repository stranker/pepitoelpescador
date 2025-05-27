class_name FishData
extends Resource

@export var fish_name : String
@export var fish_texture : Texture
@export var fish_description : String
@export var fish_gold : int
@export var fish_experience : float = 1
@export var fish_color : Color
@export var base_size : float = 0
@export var id : int = -1
@export var is_boss : bool = false

var max_weight
var unlocked : bool = false
var fish_stars : int = 1
var unlock_showed : bool = false

func initialize(stars : int, new_max_weight : float, _unlock_showed : bool):
	unlocked = true
	fish_stars = stars
	max_weight = new_max_weight
	unlock_showed = _unlock_showed
	pass
