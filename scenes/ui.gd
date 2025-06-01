extends CanvasLayer

@export var coins_label: Label
@export var coin_anim : AnimationPlayer
@export var anim : AnimationPlayer
@export var fishes_catched : HBoxContainer
@export var scrimmer : Control
@export var fps_label : Label
@export var level_name : Label

const fish_catch_info_scene = preload("res://ui/fish_catch_info.tscn")

var is_combo_visible : bool = false

signal play_available()
signal play_unavailable()

func _ready() -> void:
	GameManager.gold_update.connect(on_gold_update)
	GameManager.fish_collected.connect(on_fish_collected)
	play_available.connect(GameManager.on_ui_play_available)
	play_unavailable.connect(GameManager.on_ui_play_unavailable)
	coins_label.text = str(GameManager.game_stats.gold)
	level_name.text = GameManager.map_selected.name
	anim.play("level_presentation")
	pass

func fade_in():
	anim.play_backwards("fade_out")
	pass

func fade_out():
	anim.play("fade_out")
	pass

func on_gold_update(gold):
	coins_label.text = str(gold)
	if coin_anim.is_playing():
		coin_anim.stop()
	coin_anim.play("earn")
	pass

func on_fish_collected(fish : Fish):
	var catch_info = fish_catch_info_scene.instantiate()
	fishes_catched.add_child(catch_info)
	catch_info.set_data(fish)
	pass

func _on_cinematic_camera_end_boss_presentation() -> void:
	anim.play("presentation")
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	fps_label.text = "FPS:" + str(Engine.get_frames_per_second())
	pass

func _on_clock_end_day() -> void:
	anim.play("results")
	pass # Replace with function body.

func _on_options_button_down() -> void:
	anim.play("options")
	pass # Replace with function body.

func on_end_presentation():
	anim.play("idle")
	pass

func _on_options_panel_closed() -> void:
	anim.play("idle")
	pass # Replace with function body.
