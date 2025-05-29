extends Node

var quests : Array[QuestData]

signal quest_completed(quest)

func _ready() -> void:
	quests = DataManager.quests
	pass

func get_quest_by_id(id : int):
	for quest in quests:
		if quest.id == id:
			return quest
	return null

func on_quest_completed(quest : QuestData):
	quest_completed.emit(quest)
	pass
