extends Control

enum SelectState { PLAYER, UPGRADE }

enum State { AVAILABLE, DISABLED }

const selectable_card_scene : PackedScene = preload("res://ui/selectable_card.tscn")
@export var cards : HBoxContainer
@export var title : Label
@export var selection_type : SelectState
@export var close_button : TextureButton
var state : State = State.DISABLED

signal upgrade_card_select(upgrade)
signal character_card_selected(character)
signal back()

func _ready() -> void:
	close_button.hide()
	pass

func _show_class_cards():
	show()
	close_button.show()
	_create_character_cards()
	character_card_selected.connect(GameManager.on_character_card_selected)
	character_card_selected.connect(CardManager.on_character_card_selected)
	pass

func on_player_level_up(_level):
	#await get_tree().create_timer(1.5).timeout
	#show()
	#_create_upgrade_cards()
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
		cards.add_child(selectable_card)
		selectable_card.init(card)
		selectable_card.selected.connect(on_card_selected)
		await get_tree().create_timer(0.1).timeout
	for card in cards.get_children():
		card.enable()
	pass


func _on_close_button_down() -> void:
	for card in cards.get_children():
		card.queue_free()
	back.emit()
	pass # Replace with function body.
