class_name Collectable

extends Area2D

@export var gold : int = 5
@export var repeteable : bool = false

var initial_position : Vector2
var initial_parent : Node2D

func _ready() -> void:
	initial_position = global_position
	initial_parent = get_parent()
	pass

func hook(fish_parent : Node2D):
	re_parent(fish_parent)
	set_deferred("position", Vector2.ZERO)
	pass

func re_parent(new_parent : Node2D):
	get_parent().remove_child.call_deferred(self)
	new_parent.add_child.call_deferred(self)
	pass

func collect():
	if repeteable:
		re_parent(initial_parent)
		set_deferred("global_position", initial_position)
	else:
		queue_free()
	pass
