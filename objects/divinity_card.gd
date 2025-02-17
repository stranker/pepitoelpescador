class_name DivinityCard
extends Card

enum DivinityType {
	SMALLER_FISHES,
	BIGGER_FISHES,
	MORE_EXP,
	MORE_GOLD,
	LONGER_DAY,
	SHORTER_DAY
}

@export var divinity_type : DivinityType

func _init() -> void:
	card_type = CardType.DIVINITY
	pass

func get_description():
	return card_description
	#match divinity_type:
	#	_:
	#		return "[center]" + card_description + "[color=red]" + " " + str(upgrade_value) + "[/color]" + "[/center]"

func init():
	card_type = CardType.DIVINITY
	pass
