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

func get_type_string():
	return "PASSIVE" if type == AbilityType.PASSIVE else "ACTIVE"
