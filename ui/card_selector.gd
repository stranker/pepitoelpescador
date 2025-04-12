extends Control

enum SelectState { PLAYER, UPGRADE }

const selectable_card_scene : PackedScene = preload("res://ui/selectable_card.tscn")
@export var cards : HBoxContainer
@export var title : Label
@export var selection_type : SelectState

signal upgrade_card_select(upgrade)
signal character_card_selected(character)
signal divinity_card_selected()

func _ready() -> void:
	match selection_type:
		SelectState.PLAYER:
			if GameManager.player_selected: return
			show()
			_create_character_cards()
			character_card_selected.connect(GameManager.on_character_card_selected)
			character_card_selected.connect(CardManager.on_character_card_selected)
		SelectState.UPGRADE:
			GameManager.player_level_update.connect(on_player_level_up)
			upgrade_card_select.connect(GameManager.on_upgrade_select)
			upgrade_card_select.connect(CardManager.on_upgrade_select)
	pass

func on_player_level_up(_level):
	await get_tree().create_timer(1.5).timeout
	show()
	_create_upgrade_cards()
	pass

func on_card_selected(card_data : Card):
	for card in cards.get_children():
		if card.data != card_data:
			card.destroy()
			await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(2).timeout
	hide()
	for card in cards.get_children():
		card.queue_free()
	match card_data.card_type:
		Card.CardType.CHARACTER:
			character_card_selected.emit(card_data)
		Card.CardType.UPGRADE:
			card_data.upgrade()
			upgrade_card_select.emit(card_data)
		Card.CardType.DIVINITY:
			pass
	pass

func _create_character_cards():
	var character_cards : Array[CharacterCard] = CardManager.get_character_cards()
	character_cards.shuffle()
	_create_cards(character_cards)
	pass

func _create_upgrade_cards():
	title.text = "select an upgrade"
	var upgrade_cards : Array[UpgradeCard] = CardManager.get_upgrade_cards()
	_create_cards(upgrade_cards)
	pass

func _create_cards(cards_list : Array):
	for card in cards_list:
		var selectable_card : SelectableCard = selectable_card_scene.instantiate()
		selectable_card.init(card)
		cards.add_child(selectable_card)
		selectable_card.selected.connect(on_card_selected)
		await get_tree().create_timer(0.1).timeout
	pass

func _on_game_scene_end_day() -> void:
	#show()
	pass # Replace with function body.
