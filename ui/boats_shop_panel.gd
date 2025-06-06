extends Control

@export var boat_price : Label
@export var button_anim : AnimationPlayer
@export var day_time : StatProgressBar
@export var unlock_label : Label
@export var card : Control

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
	boat_price.text = str(data.next_price())
	card.set_boat_data(data)
	#unlock_label.text = str(data.get_unlock())
	day_time.set_data({"current_value": data.get_day_time(), "next_value": data.get_next_day_time()})
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


func _on_margin_container_gui_input(event: InputEvent) -> void:
	#if event is InputEventScreenTouch:
	#	if event.pressed:
	#		close()
	pass # Replace with function body.
