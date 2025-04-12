extends Node

@export var hooks : Array[HookStats]

var equipped_hook : HookStats = null

func _ready() -> void:
	equipped_hook = hooks.front()

func equip_hook(new_hook : HookStats):
	equipped_hook = new_hook
	for hook in hooks:
		hook.equiped = new_hook == equipped_hook
	pass
