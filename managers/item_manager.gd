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
	equipped_hook.unequip()
	equipped_hook = new_hook
	equipped_hook.equip()
	pass

func purchase_hook(hook : HookStats):
	GameManager.spend_coins(hook.get_price())
	hook.purchase()
	pass

func upgrade_hook(hook : HookStats):
	GameManager.spend_coins(hook.get_price())
	hook.upgrade()
	pass

func upgrade_boat():
	GameManager.spend_coins(boat.next_price())
	boat.upgrade()
	pass

func set_loaded_items(item_dic : Dictionary):
	pass

func set_loaded_boat(boat_tier : int):
	boat.set_tier(boat_tier)
	pass

func get_items_for_save():
	var data : Dictionary = {}
	for hook in hooks:
		data[hook.id] = {
			"level": hook.level,
			"purchased": hook.purchased,
			"equiped": hook.equiped,
		}
	return data

func get_boat_data():
	return boat.current_tier

func reset():
	for hook in hooks:
		hook.reset()
	boat.reset()
	equipped_hook = hooks.front()
	pass
