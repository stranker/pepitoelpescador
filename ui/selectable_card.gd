class_name SelectableCard
extends Control

@export var card_title : Label
@export var card_upgrade : TextureRect
@export var card_character : TextureRect
@export var card_description : RichTextLabel
@export var anim : AnimationPlayer
@export var background : NinePatchRect
var is_selected : bool = false
var is_drestroyed : bool = false
var is_interactive : bool = false

var data : Card

signal selected(card_data)

func init(card_data : Card):
	card_title.text = card_data.card_name
	if card_data.card_type == Card.CardType.CHARACTER:
		card_character.show()
		card_upgrade.hide()
		card_character.texture.atlas = card_data.card_texture
	else:
		card_character.hide()
		card_upgrade.show()
		card_upgrade.texture = card_data.card_texture
	card_description.text = card_data.get_description()
	background.texture = card_data.card_background
	data = card_data
	anim.play("appear")
	pass

func _on_mouse_entered() -> void:
	if not is_interactive: return
	if is_selected or is_drestroyed: return
	anim.play("hover")
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	if not is_interactive: return
	if is_selected or is_drestroyed: return
	anim.play("RESET")
	pass # Replace with function body.

func _on_gui_input(event: InputEvent) -> void:
	if is_selected: return
	if event.is_action_pressed("mouse_select") and event.is_pressed():
		anim.play("selected")
		is_selected = true
	pass # Replace with function body.

func card_selected():
	selected.emit(data)

func destroy():
	is_drestroyed = true
	anim.play("destroy")
	pass

func set_interactive():
	is_interactive = true
