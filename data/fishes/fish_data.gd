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

var max_weight : float = -1
var unlocked : bool = false
var fish_stars : int = 1
var unlock_showed : bool = false
var count : int = 0

func update(fish : Fish):
	if fish.weight <= max_weight: return
	max_weight = fish.weight
	fish_stars = fish.fish_stars
	unlocked = true
	count += 1
	pass

func initialize(load_fish_data : Dictionary):
	unlocked = load_fish_data.unlocked
	count = load_fish_data.count
	unlock_showed = load_fish_data.unlock_showed
	max_weight = load_fish_data.max_weight
	fish_stars = load_fish_data.fish_stars
	pass

func get_string_id():
	return str(id)

func _to_string() -> String:
	return "Fish(Name:{0},MaxWeight:{1},FishStars:{2},Unlocked:{3}, UnlockedShowed:{4})".format([fish_name, max_weight, fish_stars, unlocked, unlock_showed])

func reset():
	max_weight = -1
	fish_stars = 1
	unlocked = false
	unlock_showed = false
	count = 0
	pass
