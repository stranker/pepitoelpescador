class_name QuestData
extends Resource

enum State { INCOMPLETE, COMPLETE, CLAIMED }
enum Type { CAPTURE_SPECIFIC, CAPTURE_AMOUNT }

@export_category("Basic")
var state : State = State.INCOMPLETE
@export var id : int = -1
@export var name : String
@export var description : String
@export var texture : Texture
@export var type : Type = Type.CAPTURE_SPECIFIC
@export var capture_ammount : Array[int]
@export var rewards : Array[QuestReward]

@export var capture_ids : Array[int]

var quest_idx : int = 0
var progress : int = 0
var current_capture_ammount : int = 0

var is_claimed : bool = false

signal quest_updated()
signal quest_complete()
signal quest_claimed()

func init():
	if state == State.COMPLETE or state == State.CLAIMED: return
	if GameManager.fish_collected.is_connected(on_fish_collected): return
	GameManager.fish_collected.connect(on_fish_collected)
	current_capture_ammount = capture_ammount[quest_idx]
	pass

func on_fish_collected(fish : Fish):
	if state == State.COMPLETE or state == State.CLAIMED: return
	if capture_ids.is_empty():
		progress += 1
		_check_complete()
		quest_updated.emit()
	else:
		if capture_ids.has(fish.fish_id):
			progress += 1
			_check_complete()
			quest_updated.emit()
	pass

func _check_complete():
	if state == State.CLAIMED: return
	if progress >= current_capture_ammount:
		complete()
	pass

func get_texture():
	return texture

func complete():
	state = State.COMPLETE
	progress = clamp(progress, 0, current_capture_ammount)
	quest_complete.emit()
	if GameManager.fish_collected.is_connected(on_fish_collected):
		GameManager.fish_collected.disconnect(on_fish_collected)
	pass

func is_complete():
	return state == State.COMPLETE

func _to_string() -> String:
	return "Quest(id:{0},name:{1},type:{2},reward_type:{3})".format([id, name, type, get_current_reward()])

func get_current_reward():
	return rewards[quest_idx]

func get_quest_name():
	return name.format([current_capture_ammount])

func get_progress_label():
	return "{0}/{1}".format([progress,current_capture_ammount])

func load_save_data(data : Dictionary):
	progress = data.progress
	is_claimed = data.is_claimed
	state = int(data.state)
	quest_idx = data.quest_idx
	current_capture_ammount = capture_ammount[quest_idx]
	_check_complete()
	pass

func get_save_data():
	return {"progress":progress, "is_claimed":is_claimed, "state":state, "quest_idx":quest_idx}

func claim():
	if is_claimed: return
	state = State.CLAIMED
	is_claimed = true
	quest_claimed.emit()
	_check_repetible()
	pass

func _check_repetible():
	if quest_idx >= capture_ammount.size() - 1: return
	quest_idx += 1
	current_capture_ammount = capture_ammount[quest_idx]
	is_claimed = false
	state = State.INCOMPLETE
	progress = 0
	quest_updated.emit()
	GameManager.fish_collected.connect(on_fish_collected)
	pass

func reset():
	progress = 0
	quest_idx = 0
	current_capture_ammount = capture_ammount[quest_idx]
	state = State.INCOMPLETE
	is_claimed = false
	pass

func get_is_repetible():
	return quest_idx < capture_ammount.size() - 1
