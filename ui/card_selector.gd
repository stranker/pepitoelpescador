extends Control

enum SelectState { PLAYER, UPGRADE }

enum State { AVAILABLE, DISABLED }

const selectable_card_scene : PackedScene = preload("res://ui/selectable_card.tscn")
const ability_info_scene : PackedScene = preload("res://ui/ability_info.tscn")

@export var cards : HBoxContainer
@export var title : Label
@export var selection_type : SelectState
@export var close_button : Button
@export var selected_card_pos : Control
@export var anim : AnimationPlayer
@export var abilities : VBoxContainer

var selected_card : Card

var state : State = State.DISABLED

signal upgrade_card_select(upgrade)
signal character_card_selected(character)
signal back()

func _ready() -> void:
	close_button.hide()
	character_card_selected.connect(GameManager.on_character_card_selected)
	character_card_selected.connect(CardManager.on_character_card_selected)
	pass

func _show_class_cards():
	show()
	close_button.show()
	_create_character_cards()
	pass

func on_card_selected(selected_card : SelectableCard, card_data : Card):
	self.selected_card = card_data
	var character : CharacterCard = card_data as CharacterCard
	for ability in character.abilities:
		var ability_info = ability_info_scene.instantiate()
		abilities.add_child(ability_info)
		ability_info.set_data(ability)
	selected_card.show_info()
	var tween : Tween = create_tween()
	tween.tween_property(selected_card, "global_position", selected_card_pos.global_position, 0.2).set_ease(Tween.EASE_IN)
	tween.play()
	anim.play("card_selected")
	for card in cards.get_children():
		if card != selected_card:
			card.hide()
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

func _on_close_button_button_down() -> void:
	anim.play("idle")
	for card in cards.get_children():
		card.queue_free()
	back.emit()
	for ability_info in abilities.get_children():
		ability_info.queue_free()
	pass # Replace with function body.

func _on_cancel_button_down() -> void:
	anim.play("idle")
	for card in cards.get_children():
		card.reset()
	for ability_info in abilities.get_children():
		ability_info.queue_free()
	pass # Replace with function body.

func _on_confirm_button_down() -> void:
	character_card_selected.emit(self.selected_card)
	pass # Replace with function body.
