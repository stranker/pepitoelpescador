extends Node2D

var throw_direction : Vector2
var throw_initial_pos : Vector2

enum ThrowState { IDLE, START, END, DRAG, DISABLED }
var throw_state : ThrowState = ThrowState.IDLE
enum InteractionState { UNAVAILABLE, IDLE, THROW, RECOVER }
var interaction_state : InteractionState = InteractionState.UNAVAILABLE
var can_play : bool = true
var can_drag : bool = false

var character_data : CharacterCard

@onready var hook: Hook = $Boat/Hook
@onready var skin: PlayerSkin = $Boat/Skin
@export var force_line_anim : AnimationPlayer
@export var force_line : Node2D
@export var boat_anim : AnimationPlayer

func _ready() -> void:
	GameManager.play_available.connect(on_play_available)
	GameManager.play_unavailable.connect(on_play_unavailable)
	GameManager.end_day.connect(on_end_day)
	can_play = true
	interaction_state = InteractionState.THROW
	force_line.hide()
	_set_character_data()
	pass

func on_end_day(fishes):
	set_state(ThrowState.DISABLED)
	boat_anim.play("end")
	boat_anim.queue("end_idle")
	pass

func _set_character_data():
	character_data = CardManager.character_card
	pass

func on_play_available():
	await get_tree().create_timer(0.2).timeout
	can_play = true
	pass

func on_play_unavailable():
	can_play = false
	pass

func _unhandled_input(event: InputEvent) -> void:
	if not can_play: return
	match interaction_state:
		InteractionState.THROW:
			_handle_throw(event)
		InteractionState.RECOVER:
			_handle_recover(event)
	pass

func _handle_throw(event : InputEvent):
	if throw_state == ThrowState.END: return
	if Input.is_action_just_pressed("throw"):
		set_state(ThrowState.START)
	if event is InputEventMouseMotion and can_drag:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			set_state(ThrowState.DRAG)
	if event.is_action_released("throw") and throw_state == ThrowState.DRAG:
		set_state(ThrowState.END)
	pass

func _handle_recover(event : InputEvent):
	if event.is_action_pressed("throw"):
		hook.recover()
	pass

func set_state(new_state : ThrowState):
	throw_state = new_state
	match throw_state:
		ThrowState.IDLE:
			throw_initial_pos = global_position
			throw_direction = Vector2.DOWN
			can_drag = false
			get_tree().call_group("ui", "fade_in")
		ThrowState.START:
			throw_initial_pos = get_global_mouse_position()
			force_line.set_start(get_local_mouse_position())
			force_line.set_last(get_local_mouse_position())
			force_line.show()
			force_line_anim.play("RESET")
			can_drag = true
		ThrowState.END:
			hook.throw(throw_direction)
			force_line_anim.play("fade")
		ThrowState.DRAG:
			throw_direction = throw_initial_pos.direction_to(get_global_mouse_position()) * -1
			hook.aim(throw_direction)
			force_line.set_last(get_local_mouse_position())
		ThrowState.DISABLED:
			can_play = false
			hook.reset()
			force_line.hide()
	pass

func set_interaction_state(new_state : InteractionState):
	interaction_state = new_state
	match interaction_state:
		InteractionState.IDLE:
			await get_tree().create_timer(0.1).timeout
			set_interaction_state(InteractionState.THROW)
			pass
	pass

func _on_hook_movement_state_changed(movement_state: Hook.MovementState) -> void:
	if movement_state == Hook.MovementState.WATER:
		await get_tree().create_timer(0.5).timeout
		set_interaction_state(InteractionState.RECOVER)
	pass # Replace with function body.

func _on_hook_hook_state_changed(hook_state: Hook.HookState) -> void:
	if hook_state == Hook.HookState.IDLE:
		set_interaction_state(InteractionState.IDLE)
		set_state(ThrowState.IDLE)
	pass # Replace with function body.

func _on_cinematic_camera_end_boss_presentation() -> void:
	can_play = true
	set_interaction_state(InteractionState.IDLE)
	pass # Replace with function body.
