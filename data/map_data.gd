class_name MapData
extends Resource

@export var id : int = -1
@export var name : String
@export var description : String
@export var locked : bool
@export var image : Texture
@export var scene : PackedScene
@export var fishes : Array[FishData]
@export var quests : Array[QuestData]

var map_completed_percentage : float

func update():
	var fished_count : int = 0
	for fish in fishes:
		if fish.unlocked:
			fished_count += 1
	map_completed_percentage = fished_count / float(fishes.size())
	pass
