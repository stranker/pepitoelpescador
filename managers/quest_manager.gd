extends Node

var quests : Array[QuestData]

signal quest_completed(quest)

func _ready() -> void:
	quests = DataManager.quests
	for quest in quests:
		quest.init()
		quest.quest_complete.connect(on_quest_completed.bind(quest))
	pass

func reset():
	for quest in quests:
		quest.reset()
		quest.init()
		if not quest.quest_complete.is_connected(on_quest_completed.bind(quest)):
			quest.quest_complete.connect(on_quest_completed.bind(quest))
	pass

func get_quest_by_id(id : int):
	for quest in quests:
		if quest.id == id:
			return quest
	return null

func on_quest_completed(quest : QuestData):
	quest_completed.emit(quest)
	pass

func get_quest_for_save() -> Dictionary:
	var save_data : Dictionary
	for quest in quests:
		save_data[str(quest.id)] = quest.get_save_data()
	return save_data
