extends Node

@export var upgrade_cards : Array[UpgradeCard]
@export var character_cards : Array[CharacterCard]
const max_upgrade_cards : int = 3

var character_card : CharacterCard
var upgrade_cards_added : Array[UpgradeCard]

signal upgrade_selected(card_data)
signal character_selected(card_data)

func _ready() -> void:
	for card in upgrade_cards:
		card.init()
	pass

func get_random_upgrade_card() -> Card:
	return upgrade_cards.pick_random()

func get_character_cards() -> Array[CharacterCard]:
	return character_cards

func get_upgrade_cards() -> Array[UpgradeCard]:
	var ret_cards : Array[UpgradeCard]
	for i in range(max_upgrade_cards):
		var new_card : UpgradeCard = upgrade_cards.pick_random()
		while ret_cards.has(new_card):
			new_card = upgrade_cards.pick_random()
		ret_cards.append(new_card)
	return ret_cards

func on_selected_card(card_data : Card):
	if card_data.card_type == Card.CardType.UPGRADE:
		upgrade_selected.emit(card_data as UpgradeCard)
		if not upgrade_cards_added.has(card_data as UpgradeCard):
			upgrade_cards_added.append(card_data as UpgradeCard)
	else:
		character_card = card_data as CharacterCard
		character_selected.emit(character_card)
	pass
