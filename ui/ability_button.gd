class_name AbilityButton
extends Button

@export var ability_icon : TextureRect
@export var count_label : Label
@export var anim : AnimationPlayer

var ability_component : AbilityComponent
var ability_data : Ability
var available : bool = false

var enabled : bool = false

var cooldown : int = 0 :
	set(new_cooldown):
		cooldown = new_cooldown
		count_label.text = str(cooldown).pad_decimals(0)

func set_data(new_ability_component : AbilityComponent):
	ability_component = new_ability_component
	ability_data = ability_component.ability
	ability_icon.texture = ability_data.texture
	cooldown = ability_data.cooldown
	available = true
	enabled = ability_data.is_enabled()
	visible = enabled
	pass

func _on_button_down() -> void:
	if not available: return
	available = false
	anim.play("selected")
	pass # Replace with function body.

func on_activate():
	ability_component.activate()
	var tween : Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "cooldown", 0, ability_data.cooldown)
	tween.play()
	await tween.finished
	anim.play("idle")
	available = true
	cooldown = ability_data.cooldown
	pass

func on_end_selected():
	anim.play("cooldown")
	pass
