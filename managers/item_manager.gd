extends Node

var hooks : Array[HookStats]
@export var boat : BoatData

var equipped_hook : HookStats = null
var equipped_boat : BoatData = null

signal boat_upgraded(boat)

func _ready() -> void:
	hooks = DataManager.hooks
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
	GameManager.spend_coins(hook.get_next_price())
	hook.upgrade()
	pass

func upgrade_boat():
	GameManager.spend_coins(boat.next_price())
	boat.upgrade()
	boat_upgraded.emit(boat)
	pass

func set_loaded_items(item_dic : Dictionary):
	load_items_from_save(item_dic)
	pass

func set_loaded_boat(boat_tier : int):
	boat.set_tier(boat_tier)
	pass

func get_items_for_save():
	var data : Dictionary = {}
	for hook in hooks:
		data[str(hook.id)] = hook.get_save_data()
	return data

func load_items_from_save(data : Dictionary):
	for hook in hooks:
		var hook_data : Dictionary = data[str(hook.id)]
		hook.load_save_data(hook_data)
		if hook_data.equiped:
			equip_hook(hook)
	pass

func get_boat_data():
	return boat.current_tier

func reset():
	for hook in hooks:
		hook.reset()
	boat.reset()
	equipped_hook = hooks.front()
	pass

func get_item_texture(item_id : int):
	pass
