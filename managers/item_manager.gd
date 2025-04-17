extends Node

@export var hooks : Array[HookStats]
@export var boat : BoatData

var equipped_hook : HookStats = null
var equipped_boat : BoatData = null

func _ready() -> void:
	equipped_hook = hooks.front()
	equipped_boat = boat
	pass

func equip_hook(new_hook : HookStats):
	equipped_hook = new_hook
	for hook in hooks:
		hook.equiped = new_hook == equipped_hook
	pass

func upgrade_boat():
	GameManager.spend_coins(boat.next_price())
	boat.upgrade()
	pass
