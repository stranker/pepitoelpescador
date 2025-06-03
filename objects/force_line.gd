class_name ForceLine
extends Line2D

enum State { IDLE, INIT, DRAG, END }

var state : State = State.IDLE

var initial_pos : Vector2
var end_pos : Vector2
@export var anim : AnimationPlayer

var dragged : bool = false

func init_throw():
	set_state(State.INIT)
	pass

func drag_throw():
	set_state(State.DRAG)
	pass

func end_throw():
	set_state(State.END)
	pass

func set_state(new_state : State):
	state = new_state
	match state:
		State.IDLE:
			pass
		State.INIT:
			dragged = false
			initial_pos = get_global_mouse_position() - global_position
			points[0] = initial_pos
			anim.play("init")
		State.DRAG:
			dragged = true
			end_pos = get_global_mouse_position() - global_position
			points[1] = end_pos
		State.END:
			anim.play("end")
			dragged = false
			set_state(State.IDLE)
	pass
