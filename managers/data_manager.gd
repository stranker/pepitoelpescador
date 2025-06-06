extends Node

@export_category("Fishes")
@export var fishes : Array[FishData]
@export_category("Quests")
@export var quests : Array[QuestData]
@export_category("Maps")
@export var maps : Array[MapData]
@export_category("Hooks")
@export var hooks : Array[HookStats]

func update_fishes_data(fishes_data : Dictionary):
	for id in fishes_data.keys():
		var fish_data : FishData = get_fish(int(id))
		fish_data.initialize(fishes_data[id])
	_update_maps()
	pass

func update_quests(quests_data : Dictionary):
	for id in quests_data.keys():
		var quest_data : QuestData = get_quest(int(id))
		quest_data.load_save_data(quests_data[id])
	pass

func _update_maps():
	for map in maps:
		map.update()
	pass

func get_fish(id : int) -> FishData:
	return get_element_by_id(id, fishes)

func get_quest(id : int) -> QuestData:
	return get_element_by_id(id, quests)

func get_map(id : int) -> MapData:
	return get_element_by_id(id, maps)

func get_element_by_id(id : int, array : Array):
	for element in array:
		if element.id == id:
			return element
	return null

func get_quest_for_save() -> Dictionary:
	var save_data : Dictionary
	for quest in quests:
		save_data[str(quest.id)] = quest.get_save_data()
	return save_data

func reset():
	for fish in fishes:
		fish.reset()
	QuestManager.reset()
	for map in maps:
		map.reset()
	pass
