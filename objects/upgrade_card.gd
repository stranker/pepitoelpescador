class_name UpgradeCard
extends Card

enum UpgradeType {
	POWER,
	ACCURACY,
	RECOVER,
	LENGTH,
	BLOOD_THIRST
}

@export var upgrade_type : UpgradeType
@export_range(1, 10) var upgrade_level : int = 1
@export var upgrade_value_increment : float = 0
@export var upgrade_base_value : float = 0
@export var upgrade_color : Color = Color.GHOST_WHITE
const max_upgrade_level : int = 10
var upgrade_value : float = 0

func _init() -> void:
	card_type = CardType.UPGRADE
	pass

func get_description():
	return "[center]" + card_description + "[color=" + upgrade_color.to_html(false) + "]" + " " + str(upgrade_value) + "[/color]" + "[/center]"

func init():
	card_type = CardType.UPGRADE
	upgrade_value = upgrade_base_value + upgrade_value_increment * (upgrade_level - 1)
	pass

func upgrade():
	if upgrade_level >= max_upgrade_level: return
	upgrade_level += 1
	upgrade_value = upgrade_base_value + upgrade_value_increment * (upgrade_level - 1)
	pass
