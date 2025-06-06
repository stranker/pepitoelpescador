extends Area2D

var stun_time : float = 0

func _ready() -> void:
	await get_tree().physics_frame
	monitoring = true
	pass

func init(new_stun_time : float):
	stun_time = new_stun_time
	await get_tree().create_timer(0.5).timeout
	queue_free()
	pass

func _on_area_entered(area: Area2D) -> void:
	var fish : Fish = area as Fish
	fish.stun(stun_time)
	pass # Replace with function body.
