class_name ChaseComponent
extends Area2D

var target : Fish = null

signal start_chase(target)
signal end_chase()

func _on_area_entered(area: Area2D) -> void:
	if get_parent().fish_state == Fish.FishState.STUNED: return
	if target: return
	var fish : Fish = area as Fish
	if fish == get_parent(): return
	if fish.level >= get_parent().level: return
	if fish.fish_state != fish.FishState.HOOK: return
	target = fish
	start_chase.emit(target)
	pass # Replace with function body.

func _on_area_exited(area: Area2D) -> void:
	if get_parent().fish_state == Fish.FishState.STUNED: return
	var fish : Fish = area as Fish
	if fish == target:
		target = null
		end_chase.emit()
	pass # Replace with function body.
