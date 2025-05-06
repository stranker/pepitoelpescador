class_name Hook
extends CharacterBody2D

@export var skin : Sprite2D
@onready var fishes: Node2D = $Fishes
@onready var bubbles: CPUParticles2D = $Bubbles
@export var wind: CPUParticles2D
@onready var collectables: Node2D = $Collectables
@export var hook_force_threshold : float = 200
@export var gravity : float = 1200
@onready var camera: Camera2D = $Camera
@onready var water_splash: CPUParticles2D = $WaterSplash


var speed : float = 0
var length : float = 0
var accuracy : float = 0
var speed_decrease : float = 0
var recover_force : float = 0

const LENGTH_MULTIPLIER : float = 100
const LENGTH_LIMIT_MULTIPLIER : float = 1.5
const SPEED_MULTIPLIER : float = 400
const RECOVER_MULTIPLIER : float = 700

@onready var throw_sfx : AudioStreamPlayer = $Throw

var direction : Vector2
var initial_position : Vector2
var final_direct_position : Vector2
var clamp_y : bool = false

enum MovementState { AIR, WATER }
var movement_state = MovementState.AIR
enum HookState { IDLE, THROWN, RECOVER }
var hook_state = HookState.IDLE
@export var stats : HookStats

signal movement_state_changed(movement_state)
signal hook_state_changed(hook_state)
signal stats_updated(speed, accuracy, length, recover)
signal items_collected(count)
signal no_items_collected()

func _ready() -> void:
	set_physics_process(false)
	initial_position = global_position
	_set_hook_data()
	pass

func _set_hook_data():
	stats = ItemManager.equipped_hook
	var character_stats : CharacterCard = CardManager.character_card
	speed = (stats.get_force() + character_stats.base_power) * SPEED_MULTIPLIER
	accuracy = stats.get_accuracy() + character_stats.base_accuracy
	length = stats.get_length() * LENGTH_MULTIPLIER
	recover_force = stats.get_recover() * RECOVER_MULTIPLIER
	skin.texture = stats.texture
	stats_updated.emit(speed, accuracy, length, recover_force)
	pass

func throw(dir : Vector2):
	set_state(HookState.THROWN)
	set_physics_process(true)
	var throw_accuracy = (HookStats.MAX_ACCURACY - accuracy) / HookStats.MAX_ACCURACY
	var new_dir_angle : float = dir.angle() + randf_range(-throw_accuracy, throw_accuracy)
	direction = Vector2.from_angle(new_dir_angle).normalized()
	velocity = direction * speed
	wind.emitting = true
	final_direct_position = initial_position + Vector2.DOWN * length
	get_tree().call_group("ui", "fade_out")
	pass

func recover():
	set_state(HookState.RECOVER)
	velocity += global_position.direction_to(initial_position) * (1.0 / _get_fishes_weight()) * recover_force
	final_direct_position += Vector2.UP * 200
	pass

func _get_fishes_weight() -> float:
	var final_weight : float = 1
	for fish in fishes.get_children():
		final_weight += fish.fish_mass
	return final_weight

func aim(dir : Vector2):
	rotation = lerp_angle(rotation, dir.angle(), 0.1)
	skin.flip_v = dir.x < 0
	pass

func _physics_process(delta: float) -> void:
	match movement_state:
		MovementState.AIR:
			air_movement(delta)
		MovementState.WATER:
			water_movement(delta)
	match hook_state:
		HookState.RECOVER:
			_process_recover(delta)
	if clamp_y:
		velocity.y = 0
		if global_position.distance_to(initial_position) < 250:
			global_position = lerp(global_position, initial_position, delta * 5)
			if global_position.distance_to(initial_position) < 50:
				set_state(HookState.IDLE)
				_collect_items()
	move_and_slide()
	_clamp_length()
	pass

func _process_recover(delta):
	pass

func air_movement(delta : float):
	velocity.y += delta * gravity
	rotation = lerp_angle(rotation, velocity.angle(), 0.1)
	wind.emitting = velocity.length() > 500
	_limit_velocity()
	pass

func _clamp_length():
	position = position.limit_length(length * 0.3)
	pass

func water_movement(delta : float):
	if velocity.y < 200:
		rotation = lerp_angle(rotation, Vector2.DOWN.angle(), delta)
		velocity.y = lerpf(velocity.y, 0, delta)
	else:
		rotation = lerp_angle(rotation, velocity.angle(), delta * 2)
	velocity = velocity.lerp(global_position.direction_to(final_direct_position) * speed * 0.2, delta)
	_limit_velocity()
	pass

func _limit_velocity():
	velocity = velocity.limit_length(length * LENGTH_LIMIT_MULTIPLIER)
	pass

func set_movement_state(new_state : MovementState):
	movement_state = new_state
	match movement_state:
		MovementState.AIR:
			pass
		MovementState.WATER:
			pass
	movement_state_changed.emit(movement_state)
	pass

func set_state(new_state: HookState):
	hook_state = new_state
	match hook_state:
		HookState.IDLE:
			camera.zoom_hook_idle()
			set_physics_process(false)
			set_movement_state(MovementState.AIR)
			global_position = initial_position
			clamp_y = false
			bubbles.emitting = false
			direction = Vector2.DOWN
			pass
		HookState.THROWN:
			camera.zoom_hook_water()
			set_physics_process(true)
			throw_sfx.play()
			pass
		HookState.RECOVER:
			pass
	hook_state_changed.emit(hook_state)
	pass

func _collect_items():
	if fishes.get_children().is_empty() and collectables.get_children().is_empty():
		no_items_collected.emit()
		return
	for fish in fishes.get_children():
		if is_instance_valid(fish):
			items_collected.emit(1)
			fish.collect()
			await get_tree().create_timer(0.2).timeout
	for collectable in collectables.get_children():
		items_collected.emit(1)
		collectable.collect()
		await get_tree().create_timer(0.2).timeout
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_F4:
			reset()

func _on_water_detection_area_entered(area: Area2D) -> void:
	match movement_state:
		MovementState.AIR:
			set_movement_state(MovementState.WATER)
			wind.emitting = false
			bubbles.emitting = true
			water_splash.rotation = -rotation
			water_splash.play()
		MovementState.WATER:
			clamp_y = true
	pass

func _on_fish_detector_area_entered(area: Area2D) -> void:
	if hook_state == HookState.RECOVER: return
	if velocity.length() < hook_force_threshold: return
	var fish : Fish = area as Fish
	fish.hook(fishes)
	velocity *= speed_decrease
	pass


func _on_collectable_detector_area_entered(area: Area2D) -> void:
	if hook_state == HookState.RECOVER: return
	if velocity.length() < hook_force_threshold: return
	var collectable : Collectable = area as Collectable
	collectable.hook(collectables) 
	velocity *= speed_decrease
	pass

func on_end_boss_prensetation():
	camera.enabled = true
	pass

func reset():
	set_state(HookState.IDLE)
	for fish in fishes.get_children():
		fish.queue_free()
	pass
