class_name MapData
extends Resource

@export var name : String
@export var description : String
@export var locked : bool
@export var image : Texture
@export var scene : PackedScene
@export var fishes : Array[FishData]

var map_completed_percentage : float

func initialize(fishes_data : Dictionary):
	var fish_count : int = 0
	for fish_id in fishes_data.keys():
		for fish in fishes:
			if str(fish.id) == str(fish_id):
				fish_count += 1
				var data : Dictionary = fishes_data[str(fish_id)]
				fish.initialize(data.stars_count, data.max_weight, data.unlock_showed)
				break
	map_completed_percentage = fish_count / float(fishes.size())
	pass
