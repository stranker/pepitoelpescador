class_name Ability
extends Resource

enum AbilityType { PASSIVE, ACTIVE }

@export var name : String
@export var description : String
@export var texture : Texture
@export var type : AbilityType
@export var level_requirement : int = 0
@export var ability_component : PackedScene
@export var modifier : float
@export var duration : float = 0
@export var cooldown : float = 0

func get_type_string():
	return "PASSIVE" if type == AbilityType.PASSIVE else "ACTIVE"

func is_enabled():
	if type == AbilityType.PASSIVE: return true
	return GameManager.game_stats.player_level >= level_requirement
