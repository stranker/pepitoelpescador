extends Node2D

@export var anim : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.end_day.connect(on_end_of_day)
	pass # Replace with function body.


func on_end_of_day(_fishes):
	anim.play("end")
	pass
