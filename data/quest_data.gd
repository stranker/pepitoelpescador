class_name QuestData
extends Resource

enum RewardType { COINS, EXP, ITEM }
enum State { INCOMPLETE, COMPLETE, CLAIMED }
enum Type { CAPTURE_SPECIFIC, CAPTURE_AMOUNT }

@export_category("Basic")
@export var id : int = -1
@export var name : String
@export var description : String
@export var type : Type = Type.CAPTURE_SPECIFIC
@export var capture_count : int = 0
@export var capture_ids : Array[int]
@export var reward_type : RewardType = RewardType.COINS
@export var reward_data : int = 0
@export var state : State = State.INCOMPLETE
@export var progress : int = 0
@export var texture : Texture
@export_category("Repetible")
@export var repetible : bool = false
var repetible_count : int = 0
@export var repetible_increment: int = 0

const MAX_REPETIBLE_COUNT = 5

var is_claimed : bool = false

signal quest_updated()
signal quest_complete()
signal quest_claimed()

func init():
	if state == State.COMPLETE or state == State.CLAIMED: return
	if GameManager.fish_collected.is_connected(on_fish_collected): return
	GameManager.fish_collected.connect(on_fish_collected)
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
	if progress >= capture_count:
		complete()
	pass

func get_texture():
	return texture

func complete():
	state = State.COMPLETE
	progress = clamp(progress, 0, capture_count)
	quest_complete.emit()
	if GameManager.fish_collected.is_connected(on_fish_collected):
		GameManager.fish_collected.disconnect(on_fish_collected)
	pass

func is_complete():
	return state == State.COMPLETE

func _to_string() -> String:
	return "Quest(id:{0},name:{1},type:{2},reward_type:{3},reward_data:{4})".format([id, name, type, reward_type, reward_data])

func get_quest_name():
	return name.format([capture_count])

func get_progress_label():
	return "{0}/{1}".format([progress,capture_count])

func load_save_data(data : Dictionary):
	progress = data.progress
	is_claimed = data.is_claimed
	state = int(data.state)
	repetible_count = data.repetible_count
	capture_count = data.capture_count
	_check_complete()
	pass

func get_save_data():
	return {"progress":progress, "is_claimed":is_claimed, "state":state, "repetible_count":repetible_count, "capture_count":capture_count}

func claim():
	if is_claimed: return
	state = State.CLAIMED
	is_claimed = true
	quest_claimed.emit()
	_check_repetible()
	pass

func _check_repetible():
	if not repetible: return
	if repetible_count >= MAX_REPETIBLE_COUNT: return
	repetible_count += 1
	capture_count += repetible_increment
	reset()
	quest_updated.emit()
	GameManager.fish_collected.connect(on_fish_collected)
	pass

func reset():
	progress = 0
	state = State.INCOMPLETE
	is_claimed = false
	pass
