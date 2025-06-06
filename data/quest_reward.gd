class_name QuestReward
extends Resource

enum RewardType { COINS, EXP, ITEM }

@export var type : RewardType = RewardType.COINS
@export var texture : Texture
@export var data : int = 0

func get_texture() -> Texture:
	match type:
		RewardType.ITEM:
			return ItemManager.get_item_texture(data)
		_:
			return texture
