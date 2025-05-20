extends Control

@export var stamina_bar : ProgressBar
@export var stamina_gain : float = 5
@export var anim : AnimationPlayer

var stamina_decrease : float = 0
var fishes : Array[Fish]
var is_visible : bool = false

func _ready() -> void:
	set_physics_process(false)
	pass

func _physics_process(delta: float) -> void:
	stamina_bar.value += delta * stamina_gain
	if stamina_bar.value <= 5:
		set_physics_process(false)
		stamina_bar.value = 0
		_release_fishes()
	pass

func on_recover(force : float):
	stamina_bar.value -= (stamina_decrease / force) * 1000
	pass

func show_stamina():
	if is_visible: return
	set_physics_process(true)
	is_visible = true
	anim.play("show")
	pass

func hide_stamina():
	set_physics_process(false)
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
