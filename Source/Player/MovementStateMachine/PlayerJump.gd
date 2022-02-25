extends "res://Source/Player/MovementStateMachine/PlayerState.gd"

export(float) var decel_time = 0.8

var landed: bool = false

const landing_vfx = preload("res://Source/VFX/LandingVFX.tscn")

func _ready() -> void:
	yield(get_parent(), "ready")
	var _t = legs.connect("landed", self, "legs_landed")

func enter(init_arg: Dictionary = {}) -> void:
	.enter(init_arg)

	landed = false

	legs.set_decel_time(decel_time)

	legs.set_direction(input_direction)
	legs.jump(jump)

func check_for_new_state() -> String:
	if landed and is_zero_approx(input_direction.length_squared()):
		return "Idle"
	if landed:
		return "Walk"
	return "Jump"

func _set_input_direction(direction: Vector2) -> void:
	input_direction = direction
	legs.set_direction(direction)

func _set_jump(_jump: bool) -> void:
	jump = _jump
	legs.jump(jump)

func legs_landed() -> void:
	landed = true
	
	# TODO: Landing VFX goes here
	var lfx = landing_vfx.instance()
	get_tree().current_scene.add_child(lfx)
	lfx.global_transform.origin = Globals.player.global_transform.origin
