class_name QuestData
extends Resource

enum RewardType { COINS, EXP, ITEM }

enum Type { CAPTURE_SPECIFIC, CAPTURE_AMOUNT }

@export var id : int = -1
@export var name : String
@export var description : String
@export var type : Type = Type.CAPTURE_SPECIFIC
@export var capture_count : int = 0
@export var capture_ids : Array[int]
@export var reward_type : RewardType = RewardType.COINS
@export var reward_data : int = 0
@export var repetible : bool = false
