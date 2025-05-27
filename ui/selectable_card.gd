class_name SelectableCard
extends Control

@export var card_title : Label
@export var card_image : TextureRect
@export var card_description : RichTextLabel
@export var anim : AnimationPlayer
@export var description_anim : AnimationPlayer
@export var star_list : HBoxContainer
@export var attributes : VBoxContainer

@export var power_progress : StatProgressBar
@export var accuracy_progress : StatProgressBar

var is_selected : bool = false
var is_drestroyed : bool = false
var is_interactive : bool = false

var data : Card

signal selected(card, card_data)

func reset():
	is_selected = false
	anim.play("RESET")
	for attribute in attributes.get_children():
		attribute.reset()
	show()
	pass

func show_info():
	for attribute in attributes.get_children():
		attribute.hover()
	anim.play("hover")
	pass

func init(card_data : Card):
	card_title.text = card_data.card_name
	if card_data.card_type == Card.CardType.CHARACTER:
		var card = card_data as CharacterCard
		card_image.texture = AtlasTexture.new()
		card_image.texture.region = Rect2(12, 0, 42, 42)
		card_image.texture.atlas = card_data.card_texture
		power_progress.set_data({"current_value":card.base_power})
		accuracy_progress.set_data({"current_value":card.base_accuracy})
	else:
		var card = card_data as UpgradeCard
		for i in range(card.upgrade_level):
			star_list.get_child(i).self_modulate = Color.DARK_ORANGE
		_animate_upgrade_star(star_list.get_child(card.upgrade_level - 1))
		card_image.texture = card_data.card_texture
	card_description.text = card_data.get_description()
	data = card_data
	anim.play("appear")
	pass

func _animate_upgrade_star(star : Control):
	var color = star.self_modulate
	var tween : Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(star, "self_modulate", Color(color.r,color.g,color.b,0.2), 0.3).set_ease(Tween.EASE_IN)
	tween.tween_property(star, "self_modulate", Color(color.r,color.g,color.b,1.0), 0.3).set_ease(Tween.EASE_IN).set_delay(0.5)
	tween.set_loops()
	tween.play()
	pass

func _on_mouse_entered() -> void:
	if not is_interactive: return
	if is_selected or is_drestroyed: return
	show_info()
	pass

func _on_mouse_exited() -> void:
	if not is_interactive: return
	if is_selected or is_drestroyed: return
	for attribute in attributes.get_children():
		attribute.reset()
	anim.play("RESET")
	pass

func _on_gui_input(event: InputEvent) -> void:
	if not is_interactive: return
	if is_selected: return
	if event.is_action_pressed("mouse_select") and event.is_pressed():
		anim.play("selected")
		is_selected = true
	pass

func card_selected():
	selected.emit(self, data)
	pass

func destroy():
	is_drestroyed = true
	anim.play("destroy")
	pass

func disable():
	is_interactive = false
	pass

func enable():
	is_interactive = true
	pass
