class_name CharacterCard
extends Card

enum CharacterType {
	HUNTRESS,
	BUSINESS,
	POWER_BUILDER
}

@export var character_type : CharacterType
@export var base_power : float = 0
@export var base_accuracy: float = 0
@export var abilities : Array[Ability]

func _init() -> void:
	card_type = CardType.CHARACTER

func get_description():
	return "[center]" + card_description + "[/center]"
