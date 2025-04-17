extends Control

@export var boat_texture : TextureRect
@export var boat_price : Label
@export var button_anim : AnimationPlayer
@export var day_time_pb : ProgressBar
@export var boat_anim : AnimationPlayer

signal closed

var data : BoatData

func _ready() -> void:
	data = ItemManager.boat
	_refresh_ui()
	pass

func close():
	closed.emit()
	pass

func _on_close_button_button_down() -> void:
	close()
	pass # Replace with function body.

func _refresh_ui():
	boat_anim.play("tier_" + str(data.current_tier + 1))
	boat_price.text = str(data.next_price())
	day_time_pb.value = data.day_time_values[data.current_tier]
	if data.next_price() < 0:
		button_anim.play("hide")
	else:
		if data.next_price() <= GameManager.game_stats.gold:
			button_anim.play("idle")
		else:
			button_anim.play("disabled")
	pass


func _on_visibility_changed() -> void:
	if not visible: return
	_refresh_ui()
	pass # Replace with function body.


func _on_upgrade_button_button_down() -> void:
	ItemManager.upgrade_boat()
	_refresh_ui()
	pass # Replace with function body.
