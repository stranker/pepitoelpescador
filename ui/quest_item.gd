class_name QuestItem
extends Control

@export var title : Label
@export var target_icon : TextureRect
@export var texture_reward : TextureRect
@export var label_reward : Label
@export var progress_label : Label
@export var anim : AnimationPlayer

signal quest_claimed(quest)

var quest_ref : QuestData

func _ready() -> void:
	quest_claimed.connect(GameManager.on_quest_claimed)
	pass

func set_data(quest : QuestData):
	quest.quest_claimed.connect(on_quest_claimed.bind(quest))
	quest.quest_updated.connect(on_quest_updated.bind(quest))
	_refresh_ui(quest)
	pass

func _refresh_ui(quest : QuestData):
	quest_ref = quest
	title.text = quest.get_quest_name()
	target_icon.texture = quest.get_texture()
	label_reward.text = str(quest.reward_data)
	progress_label.text = quest.get_progress_label()
	match quest.state:
		QuestData.State.CLAIMED:
			anim.play("claimed")
		QuestData.State.COMPLETE:
			anim.play("complete")
		QuestData.State.INCOMPLETE:
			anim.play("incomplete")
	pass

func on_quest_updated(quest : QuestData):
	_refresh_ui(quest)
	pass

func on_quest_claimed(quest : QuestData):
	quest_claimed.emit(quest)
	anim.play("claimed")
	pass

func _on_claim_button_down() -> void:
	quest_ref.claim()
	pass # Replace with function body.
