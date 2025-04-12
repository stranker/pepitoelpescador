extends Control

@export var name_label : Label
@export var speed_pb : ProgressBar
@export var length_pb : ProgressBar
@export var accuracy_pb : ProgressBar
@export var texture : TextureRect
@export var buttons_anim : AnimationPlayer

signal closed

var current_hook_idx = 0

var data : HookStats

func _ready():
	$MarginContainer/Info/LeftButton.visible = false
	set_data(ItemManager.hooks[current_hook_idx])
	pass

func set_data(hook_data : HookStats):
	data = hook_data
	name_label.text = hook_data.name
	speed_pb.value = hook_data.force
	length_pb.value = hook_data.length
	accuracy_pb.value = hook_data.accuracy
	texture.texture = hook_data.texture
	if hook_data.purchased:
		if hook_data.equiped:
			buttons_anim.play("equiped")
		else:
			buttons_anim.play("purchased")
	elif hook_data.price <= GameManager.game_stats.gold:
		buttons_anim.play("idle")
	else:
		buttons_anim.play("cant_purchase")
	pass


func _on_close_button_down() -> void:
	closed.emit()
	pass # Replace with function body.


func _on_left_button_button_down() -> void:
	current_hook_idx -= 1
	current_hook_idx = clamp(current_hook_idx, 0, ItemManager.hooks.size() - 1)
	set_data(ItemManager.hooks[current_hook_idx])
	$MarginContainer/Info/LeftButton.visible = current_hook_idx > 0
	$MarginContainer/Info/RightButton.visible = current_hook_idx < ItemManager.hooks.size() - 1
	pass # Replace with function body.


func _on_right_button_button_down() -> void:
	current_hook_idx += 1
	current_hook_idx = clamp(current_hook_idx, 0, ItemManager.hooks.size() - 1)
	set_data(ItemManager.hooks[current_hook_idx])
	$MarginContainer/Info/RightButton.visible = current_hook_idx < ItemManager.hooks.size() - 1
	$MarginContainer/Info/LeftButton.visible = current_hook_idx > 0
	pass # Replace with function body.


func _on_buy_button_button_down() -> void:
	data.purchased = true
	_refresh_ui()
	pass # Replace with function body.


func _on_equip_button_button_down() -> void:
	ItemManager.equip_hook(data)
	_refresh_ui()
	pass # Replace with function body.

func _refresh_ui():
	set_data(data)
	pass
