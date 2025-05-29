extends Node

@export_category("Fishes")
@export var fishes : Array[FishData]
@export_category("Quests")
@export var quests : Array[QuestData]
@export_category("Maps")
@export var maps : Array[MapData]

func update_fishes_data(fishes_data : Dictionary):
	for id in fishes_data.keys():
		for fish in fishes:
			if fish.get_string_id() == str(id):
				fish.initialize(fishes_data[str(id)])
				break
	_update_maps()
	pass

func _update_maps():
	for map in maps:
		map.update()
	pass

func get_fish(id : int):
	return get_element_by_id(id, fishes)

func get_quest(id : int):
	return get_element_by_id(id, quests)

func get_map(id : int):
	return get_element_by_id(id, maps)

func get_element_by_id(id : int, array : Array):
	for element in array:
		if element.id == id:
			return element
	return null
