class_name EatComponent
extends Area2D

signal start_eat()
signal end_eat()
signal eat()

@onready var eat_timer: Timer = $EatTimer

func _on_area_entered(area: Area2D) -> void:
	var fish : Fish = area as Fish
	if fish == get_parent(): return
	if fish.fish_state != Fish.FishState.HOOK: return
	if fish != get_parent().target: return
	start_eat.emit()
	eat_timer.start()
	pass # Replace with function body.


func _on_area_exited(area: Area2D) -> void:
	var fish : Fish = area as Fish
	if fish == get_parent(): return
	if fish != get_parent().target: return
	#print_debug("Exit Eat Fish:", fish.name, " - EATER:", get_parent().name)
	end_eat.emit()
	eat_timer.stop()
	pass

func _on_eat_timer_timeout() -> void:
	eat.emit()
	pass # Replace with function body.
