class_name StatProgressBar
extends VBoxContainer

@export var stat_label : Label
@export var current_progress : ProgressBar
@export var next_progress : ProgressBar
@export var anim : AnimationPlayer

@export var stat_name : String
@export var min_value : float
@export var max_value : float

func _ready() -> void:
	stat_label.text = stat_name
	current_progress.max_value = max_value
	current_progress.min_value = min_value
	current_progress.value = 0
	next_progress.max_value = max_value
	next_progress.min_value = min_value
	next_progress.value = 0
	pass

func set_data(data : Dictionary):
	if data.has("current_value"):
		current_progress.value = data.current_value
	if data.has("next_value"):
		next_progress.value = data.next_value
	pass

func reset():
	anim.play("RESET")

func hover():
	anim.play("hover")
