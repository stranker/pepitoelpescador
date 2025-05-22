extends Control

enum State { USING, COMPLETE, DEPLETE, CHARGE, LAST }

@export var stamina_bar : ProgressBar
@export var stamina_gain : float = 5
@export var anim : AnimationPlayer
@export var state : State = State.LAST
@export var normal_color : Color
@export var warning_color : Color
@export var deplete_color : Color

const WARNING_THRESHOLD : float = 0.667
const DEPLETE_THRESHOLD : float = 0.334

var stamina_decrease : float = 0
var fishes : Array[Fish]
var is_visible : bool = false

func _ready() -> void:
	set_state(State.COMPLETE)
	GameManager.end_day.connect(on_end_of_day)
	pass

func on_end_of_day(_fishes):
	hide_stamina()
	pass

func _physics_process(delta: float) -> void:
	stamina_bar.value += delta * (stamina_gain if state == State.USING else stamina_gain * 10)
	var progress = stamina_bar.value / stamina_bar.max_value
	if progress >= WARNING_THRESHOLD:
		_tween_color(normal_color)
	elif progress > DEPLETE_THRESHOLD and progress < WARNING_THRESHOLD:
		_tween_color(warning_color)
	elif progress >= 0 and progress <= DEPLETE_THRESHOLD:
		_tween_color(deplete_color)
	if stamina_bar.value >= stamina_bar.max_value:
		set_state(State.COMPLETE)
	pass

func _tween_color(color : Color):
	var fill_style_box : StyleBoxFlat = stamina_bar.get_theme_stylebox("fill")
	var tween : Tween = create_tween()
	tween.tween_property(fill_style_box,"bg_color", color, 0.2).set_ease(Tween.EASE_IN)
	tween.play()
	pass

func set_state(new_state : State):
	if state == new_state: return
	state = new_state
	match state:
		State.COMPLETE:
			on_complete_state()
		State.USING:
			on_using_state()
		State.DEPLETE:
			on_deplete_state()
		State.CHARGE:
			on_charge_state()
	pass

func on_complete_state():
	set_physics_process(false)
	stamina_bar.value = stamina_bar.max_value
	pass

func on_using_state():
	set_physics_process(true)
	pass

func on_deplete_state():
	_release_fishes()
	set_physics_process(false)
	anim.play("deplete")
	pass

func on_charge_state():
	set_physics_process(true)
	pass

func on_recover(force : float):
	if state == State.DEPLETE: return
	set_state(State.USING)
	stamina_bar.value -= (stamina_decrease / force) * 2000
	if stamina_bar.value <= 5:
		set_state(State.DEPLETE)
	pass

func show_stamina():
	if is_visible: return
	is_visible = true
	anim.play("show")
	pass

func hide_stamina():
	is_visible = false
	fishes.clear()
	anim.play_backwards("show")
	pass

func on_fish_hook_enter(fish : Fish):
	if fishes.has(fish): return
	fishes.append(fish)
	show_stamina()
	_calculate_stamina_decrease()
	pass

func on_fish_hook_exit(fish : Fish):
	if !fishes.has(fish): return
	fishes.erase(fish)
	_calculate_stamina_decrease()
	if fishes.is_empty():
		hide_stamina()
	pass

func _release_fishes():
	for fish in fishes:
		fish.release()
	pass

func _calculate_stamina_decrease():
	stamina_decrease = 0
	for fish in fishes:
		stamina_decrease += fish.fish_mass
	pass
