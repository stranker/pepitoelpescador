class_name Fish
extends Area2D

enum FishState { IDLE, MOVE, CHASE, HOOK, COLLECT, EAT, EATED, BEIGN_EATED }

var states : Array = [
	{ "anim": "idle" }, #IDLE
	{ "enter" : move_enter, "update" : move_update, "anim": "move" }, #MOVE
	{ "update" : chase_update, "anim": "chase" }, #CHASE
	{ "enter" : hook_enter, "anim": "hook" }, #HOOK
	{ "anim": "collect"}, #COLLECT
	{ "update" : eat_update , "anim": "eat"}, #EAT
	{ "enter" : eated_enter, "exit" : eated_exit, "anim": "eated"}, #EATED
	{ "enter" : being_eated_enter, "exit" : being_eated_exit, "anim": "start_eated"} #BEING_EATED
]

@export var speed : float = 500
@export var fish_state : FishState = FishState.IDLE
@export var fish_mass : float = 10.0
@export var level : int = 0
@export var fish_id : int = -1
var fish_data : FishData

const shockwave_scene = preload("res://sfx/shockwave.tscn")

@onready var movement_timer: Timer = $MovementTimer

@onready var debug_ui: Control = $Debug
@onready var movement_rect: ReferenceRect = $Debug/MovementRect
@onready var debug_state: Label = $Debug/State

@onready var sprite_2d: Sprite2D = $Visual/Sprite2D
@export var anim: AnimationPlayer
@onready var eated_particles : CPUParticles2D = $Visual/Eated
@onready var eat_icon: AnimatedSprite2D = $IconPivot/EatIcon
@onready var alert_icon: Sprite2D = $IconPivot/AlertIcon
@onready var icon_pivot: Node2D = $IconPivot

@onready var chase_component: ChaseComponent = $ChaseComponent
@onready var eat_component: EatComponent = $EatComponent

var initial_pos : Vector2
var movement_pos : Vector2
var velocity : Vector2
var initial_parent : Node2D
var target : Fish = null
var fish_scales : Array = [0.9, 0.95, 1.0, 1.05, 1.1]
var fish_stars : int = 1
var weight : float = 1
var is_enabled : bool = true
var fish_gold : int = 0

signal collected(fish)

func _ready() -> void:
	await get_tree().process_frame
	fish_data = DataManager.get_fish(fish_id)
	initial_pos = global_position
	if get_parent() is not Control:
		initial_parent = get_parent()
	get_new_position()
	set_fish_state(FishState.MOVE)
	debug_ui.visible = GameManager.debug_enabled
	collected.connect(GameManager.collect_fish)
	fish_stars = (randi() % 5) + 1 if not fish_data.is_boss else 5
	reset_gold()
	scale = Vector2.ONE * fish_scales[fish_stars - 1]
	weight = fish_data.base_size * fish_scales[fish_stars - 1] + randf_range(0.0, 1.2)
	if fish_data:
		eated_particles.modulate = fish_data.fish_color
	pass

func move_enter():
	chase_component.set_deferred("monitoring", true)
	chase_component.set_deferred("monitorable", false)
	eat_component.set_deferred("monitoring", true)
	pass

func move_update(delta):
	velocity = follow_target(movement_pos, speed)
	if global_position.distance_to(movement_pos) < 100:
		get_new_position()
	debug_ui.rotation = -rotation
	movement_rect.global_position = initial_pos - movement_rect.size * 0.5
	queue_redraw()
	pass

func chase_update(delta):
	if target and (target.fish_state == FishState.HOOK or target.fish_state == FishState.BEIGN_EATED):
		velocity = follow_target(target.global_position, speed)
	else:
		return FishState.MOVE

func hook_enter():
	set_physics_process(false)
	chase_component.set_deferred("monitoring", false)
	chase_component.set_deferred("monitorable", true)
	eat_component.set_deferred("monitoring", false)
	var shockwave = shockwave_scene.instantiate()
	add_child(shockwave)
	GameManager.stop_frames(12)
	get_tree().call_group("ui", "on_fish_hook_enter", self)
	pass

func eated_enter():
	get_tree().call_group("ui", "on_fish_hook_exit", self)
	await get_tree().create_timer(3).timeout
	queue_free()
	pass

func eated_exit():
	stop_eated()
	pass

func start_eated():
	set_fish_state(FishState.BEIGN_EATED)
	pass

func stop_eated():
	anim.call_deferred("play","RESET")
	fish_state = FishState.HOOK
	pass

func being_eated_enter():
	pass

func being_eated_exit():
	anim.play("RESET")
	pass

func eat_update(delta : float):
	if not target: return
	velocity = follow_target(target.global_position, speed * 0.2)
	pass

func _physics_process(delta: float) -> void:
	if states[fish_state].has("update"):
		var new_state = Callable(states[fish_state].update).call(delta)
		if new_state != null:
			set_fish_state(new_state)
	sprite_2d.flip_v = velocity.x < 0
	icon_pivot.rotation = 0.0 if velocity.x > 0 else -rotation
	rotation = atan2(velocity.y, velocity.x)
	eat_icon.rotation = -rotation
	alert_icon.rotation = -rotation
	translate(velocity * delta)
	pass

func follow_target(new_target : Vector2, follow_speed : float):
	var desired_velocity = global_position.direction_to(new_target) * follow_speed
	var steer_velocity = (desired_velocity - velocity) / fish_mass
	return velocity + steer_velocity

func _on_movement_timer_timeout() -> void:
	get_new_position()
	pass # Replace with function body.

func get_new_position():
	var half_rect : Vector2 = movement_rect.size * 0.5
	movement_pos = initial_pos + Vector2(randf_range(-half_rect.x, half_rect.x),randf_range(-half_rect.y, half_rect.y))
	while global_position.distance_to(movement_pos) < 200:
		movement_pos = initial_pos + Vector2(randf_range(-half_rect.x, half_rect.x),randf_range(-half_rect.y, half_rect.y))
	movement_timer.start()
	pass

func set_fish_state(new_state : FishState):
	if new_state == fish_state: return
	#print("fish:", name, " - set_fish_state:", FishState.keys()[new_state])
	debug_state.text = "State:" + FishState.keys()[new_state]
	if states[fish_state].has("exit"):
		Callable(states[fish_state].exit).call()
	fish_state = new_state
	if states[fish_state].has("enter"):
		Callable(states[fish_state].enter).call()
	anim.play("RESET")
	if states[fish_state].has("anim"):
		anim.queue.call_deferred(states[fish_state].anim)
	pass

func hook(fish_parent : Node2D):
	if not is_enabled: return
	if fish_state == FishState.HOOK: return
	if fish_state == FishState.COLLECT: return
	if fish_state == FishState.EAT:
		target.stop_eated()
	set_fish_state.call_deferred(FishState.HOOK)
	reparent.call_deferred(fish_parent)
	set_deferred("position", Vector2.ZERO)
	pass

func collect():
	collected.emit(self)
	is_enabled = false
	get_tree().call_group("ui", "on_fish_hook_exit", self)
	queue_free()
	pass

func _on_chase_component_start_chase(new_target: Variant) -> void:
	if fish_state == FishState.HOOK: return
	target = new_target
	set_fish_state.call_deferred(FishState.CHASE)
	pass # Replace with function body.

func _on_chase_component_end_chase() -> void:
	if fish_state == FishState.HOOK: return
	set_fish_state.call_deferred(FishState.MOVE)
	set_deferred("target", null)
	pass # Replace with function body.

func _on_eat_component_start_eat() -> void:
	if fish_state == FishState.HOOK: return
	set_fish_state.call_deferred(FishState.EAT)
	if target:
		target.start_eated()
	pass # Replace with function body.

func _on_eat_component_end_eat() -> void:
	if fish_state == FishState.HOOK: return
	if target and target.fish_state != FishState.EATED:
		set_fish_state.call_deferred(FishState.CHASE)
		target.stop_eated()
	else:
		set_fish_state.call_deferred(FishState.MOVE)
	pass # Replace with function body.

func release():
	is_enabled = false
	reparent(initial_parent)
	set_fish_state(FishState.MOVE)
	get_new_position()
	var tween : Tween = create_tween()
	tween.tween_property(self,"modulate", Color(1,1,1,0), 0.5).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
	tween.play()
	get_tree().call_group("ui", "on_fish_hook_exit", self)
	pass

func _on_eat_component_eat() -> void:
	if fish_state == FishState.HOOK: return
	if not target: return
	chase_component.set_deferred("monitoring", false)
	eat_component.set_deferred("monitoring", false)
	target.reparent.call_deferred(eat_component)
	target.set_fish_state.call_deferred(FishState.EATED)
	set_deferred("target", null)
	set_fish_state.call_deferred(FishState.MOVE)
	pass # Replace with function body.

func increase_gold(value : float):
	fish_gold *= value
	pass

func reset_gold():
	fish_gold = fish_data.fish_gold + fish_stars
	pass
