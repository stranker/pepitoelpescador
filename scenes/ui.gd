extends CanvasLayer

@export var coins_label: Label
@export var coin_anim : AnimationPlayer
@export var anim : AnimationPlayer
@export var fishes_catched : HBoxContainer
@export var scrimmer : Control
@export var player_portrait_anim : AnimationPlayer
@export var experience_bar : TextureProgressBar
@export var profile : TextureRect
@export var level_label : Label
@export var combo_label : Label
@export var combo_anim : AnimationPlayer
@export var book_panel : Control

const fish_catch_info_scene = preload("res://ui/fish_catch_info.tscn")

var is_combo_visible : bool = false

signal play_available()
signal play_unavailable()

func _ready() -> void:
	GameManager.gold_update.connect(on_gold_update)
	GameManager.fish_collected.connect(on_fish_collected)
	GameManager.player_level_update.connect(on_player_level_update)
	GameManager.experience_update.connect(on_experience_update)
	GameManager.divinity_day.connect(on_divinity_day)
	CardManager.character_selected.connect(on_character_selected)
	play_available.connect(GameManager.on_ui_play_available)
	play_unavailable.connect(GameManager.on_ui_play_unavailable)
	coins_label.text = str(GameManager.game_stats.gold)
	experience_bar.max_value = GameManager.game_stats.player_level * GameManager.experience_increment
	level_label.text = str(GameManager.game_stats.player_level)
	pass # Replace with function body.

func on_divinity_day():
	pass

func on_player_level_update(lvl):
	experience_bar.max_value = lvl * GameManager.experience_increment
	experience_bar.value = 0
	player_portrait_anim.queue("level_up")
	pass

func set_level_text():
	level_label.text = str(GameManager.game_stats.player_level)
	pass

func on_character_selected(char : CharacterCard):
	profile.texture.atlas = char.card_texture
	pass

func on_gold_update(gold):
	coins_label.text = str(gold)
	coin_anim.queue("earn")
	pass

func fade_out():
	anim.play("fade_out")
	pass

func fade_in():
	anim.play_backwards("fade_out")
	pass

func on_fish_collected(fish : Fish):
	var catch_info = fish_catch_info_scene.instantiate()
	fishes_catched.add_child(catch_info)
	catch_info.set_data(fish)
	pass

func on_experience_update(experience):
	player_portrait_anim.queue("add_exp")
	var tween : Tween = create_tween()
	tween.tween_property(experience_bar, "value", experience, 0.5).set_ease(Tween.EASE_IN)
	tween.play()
	pass

func on_items_collected(count : int):
	if not is_combo_visible:
		is_combo_visible = true
		combo_anim.play("enter")
	else:
		combo_anim.play("add")
	combo_label.text = "X" + str(count)
	pass

func on_not_items_collected():
	if is_combo_visible:
		combo_anim.play_backwards("enter")
		is_combo_visible = false
	pass

func _on_cinematic_camera_end_boss_presentation() -> void:
	anim.play_backwards("fade_out")
	pass # Replace with function body.

func _on_book_button_button_down() -> void:
	book_panel.show_panel()
	pass # Replace with function body.
