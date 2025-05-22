class_name AbilityButton
extends Button

@export var texture_progress : TextureProgressBar

var ability_component : AbilityComponent
var ability_data : Ability
var available : bool = false

func set_data(new_ability_component : AbilityComponent):
	ability_component = new_ability_component
	ability_data = ability_component.ability
	texture_progress.texture_under = ability_data.texture
	texture_progress.texture_progress = ability_data.texture
	available = true
	pass

func _on_button_down() -> void:
	if not available: return
	available = false
	ability_component.activate()
	texture_progress.value = 0
	var tween : Tween = create_tween()
	tween.tween_property(texture_progress, "value", texture_progress.max_value, ability_data.cooldown)
	tween.play()
	await tween.finished
	available = true
	pass # Replace with function body.
