extends Control

@export var tabs_icons : Array[Texture2D]
@export var fishes_panel : Control
@export var tabs : TabContainer

func _ready() -> void:
	hide()
	for i in range(tabs.get_child_count()):
		tabs.set_tab_icon(i, tabs_icons[i])
		tabs.set_tab_title(i,"")
	pass

func set_level_data(level_data : Level.LevelData):
	fishes_panel.set_fishes(level_data.fishes)
	pass

func _on_close_button_button_down() -> void:
	get_tree().set_pause(false)
	hide()
	pass # Replace with function body.

func show_panel():
	show()
	get_tree().set_pause(true)
	pass
