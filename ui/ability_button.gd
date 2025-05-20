extends Button

@export var texture_progress : TextureProgressBar

@export var ability_data : Ability
var available : bool = false

signal selected(ability)

func _ready() -> void:
	if not ability_data: return
	set_data(ability_data)
	pass

func set_data(ability : Ability):
	ability_data = ability
	texture_progress.texture_under = ability.texture
	texture_progress.texture_progress = ability.texture
	available = true
	pass

func _on_button_down() -> void:
	if not available: return
	available = false
	selected.emit(ability_data)
	texture_progress.value = 0
	var tween : Tween = create_tween()
	tween.tween_property(texture_progress, "value", texture_progress.max_value, ability_data.cooldown)
	tween.play()
	await tween.finished
	available = true
	pass # Replace with function body.
