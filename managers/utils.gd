extends Node

class ResultItemData:
	var id : int = -1
	var texture : Texture
	var count : int = 0
	var weight : float = 0
	var gold : int = 0
	var increment : float = 0
	
	func init(fish : Fish) -> void:
		id = fish.fish_id
		texture = fish.fish_data.fish_texture
		weight = fish.fish_data.max_weight
		count = 1
		gold = fish.fish_gold
		increment = gold * GameManager.gold_increment
		pass
	
	func update(fish : Fish):
		count += 1
		gold += fish.fish_gold
		increment = gold * GameManager.gold_increment
		if weight < fish.fish_data.max_weight:
			weight = fish.fish_data.max_weight
		pass
