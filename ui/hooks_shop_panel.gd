extends Control

@export var speed_stat : StatProgressBar
@export var length_stat : StatProgressBar
@export var accuracy_stat : StatProgressBar
@export var recover_stat : StatProgressBar

@export var buttons_anim : AnimationPlayer
@export var upgrade_label : Label
@export var buy_label : Label

@export var right_button : TextureButton
@export var left_button : TextureButton
@export var upgrade_button : Button

@export var buy_offer : TextureRect
@export var buy_offer_label : Label

@export var upgade_offer : TextureRect
@export var upgrade_offer_label : Label

@export var card : Control

signal closed

var current_hook_idx = 0

var data : HookStats

func _ready():
	left_button.visible = false
	var hook_found : bool = false
	for hook in ItemManager.hooks:
		if hook.equiped:
			set_data(hook)
			hook_found = true
			break
		current_hook_idx += 1
	if not hook_found:
		current_hook_idx = 0
	_check_change_buttons()
	pass

func set_data(hook_data : HookStats):
	data = hook_data
	card.set_hook_data(hook_data)
	
	speed_stat.set_data({"current_value": hook_data.get_force(), "next_value": hook_data.get_next_force()})
	length_stat.set_data({"current_value": hook_data.get_length(), "next_value": hook_data.get_next_length()})
	accuracy_stat.set_data({"current_value": hook_data.get_accuracy(), "next_value": hook_data.get_next_accuracy()})
	recover_stat.set_data({"current_value": hook_data.get_recover(), "next_value": hook_data.get_next_recover()})
	
	upgrade_label.text = str(hook_data.get_next_price())
	buy_label.text = str(hook_data.get_price())
	buy_offer.visible = hook_data.price_discount != 0
	buy_offer_label.text = "{0}%".format([int(hook_data.price_discount * 100)])
	if hook_data.purchased:
		if hook_data.equiped:
			buttons_anim.play("equiped")
		else:
			buttons_anim.play("purchased")
		_check_upgrade_button()
	elif _can_buy():
		buttons_anim.play("idle")
	else:
		buttons_anim.play("cant_purchase")
	pass

func _check_upgrade_button():
	if data.is_max_level():
		upgrade_button.visible = false
		buttons_anim.queue("no_upgrade")
	else:
		if _can_upgrade():
			buttons_anim.queue("upgrade_enabled")
		else:
			buttons_anim.queue("upgrade_disabled")
		upgade_offer.visible = data.price_discount != 0
		upgrade_offer_label.text = "{0}%".format([int(data.price_discount * 100)])
	pass

func _can_buy():
	return data.get_price() <= GameManager.game_stats.gold

func _can_upgrade():
	return data.get_next_price() <= GameManager.game_stats.gold

func _on_left_button_button_down() -> void:
	current_hook_idx -= 1
	current_hook_idx = clamp(current_hook_idx, 0, ItemManager.hooks.size() - 1)
	set_data(ItemManager.hooks[current_hook_idx])
	_check_change_buttons()
	pass # Replace with function body.

func _on_right_button_button_down() -> void:
	current_hook_idx += 1
	current_hook_idx = clamp(current_hook_idx, 0, ItemManager.hooks.size() - 1)
	set_data(ItemManager.hooks[current_hook_idx])
	_check_change_buttons()
	pass # Replace with function body.

func _check_change_buttons():
	left_button.visible = current_hook_idx > 0
	right_button.visible = current_hook_idx < ItemManager.hooks.size() - 1
	right_button.visible = current_hook_idx < ItemManager.hooks.size() - 1
	left_button.visible = current_hook_idx > 0
	pass

func _on_buy_button_button_down() -> void:
	ItemManager.purchase_hook(data)
	_refresh_ui()
	GameManager.save_game_data()
	pass # Replace with function body.


func _on_equip_button_button_down() -> void:
	ItemManager.equip_hook(data)
	_refresh_ui()
	GameManager.save_game_data()
	pass # Replace with function body.

func _refresh_ui():
	if not data: return
	set_data(data)
	pass

func _on_upgrade_button_button_down() -> void:
	ItemManager.upgrade_hook(data)
	_refresh_ui()
	GameManager.save_game_data()
	pass # Replace with function body.

func _on_visibility_changed() -> void:
	if visible:
		_refresh_ui()
	pass # Replace with function body.

func _on_close_button_button_down() -> void:
	closed.emit()
	pass # Replace with function body.

func _on_button_animation_animation_changed(old_name: StringName, new_name: StringName) -> void:
	print_debug(old_name, " -> ", new_name)
	pass # Replace with function body.

func _on_margin_container_gui_input(event: InputEvent) -> void:
	#if event is InputEventScreenTouch:
	#	if event.pressed:
	#		closed.emit()
	pass # Replace with function body.
