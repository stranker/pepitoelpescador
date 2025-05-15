class_name MapData
extends Resource

@export var name : String
@export var description : String
@export var locked : bool
@export var image : Texture
@export var scene : PackedScene
@export var fishes : Array[FishData]

var map_completed_percentage : float

func initilize(fishes_ids : Array):
	var fish_count : int = 0
	for fish_id in fishes_ids:
		for fish in fishes:
			if fish.id == int(fish_id):
				fish_count += 1
				break
	map_completed_percentage = fish_count / float(fishes.size())
	print_debug(map_completed_percentage)
	pass
