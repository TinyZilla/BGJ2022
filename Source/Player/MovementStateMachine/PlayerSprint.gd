extends "res://Source/Player/MovementStateMachine/PlayerState.gd"

export(float) var max_velocity: float = 15.0
export(float) var accel_time: float = 0.15
export(float) var decel_time: float = 0.4

# Maybe add more limitation here so that you can only sprint forwards...

func enter(init_arg: Dictionary = {}) -> void:
	.enter(init_arg)

	legs.set_max_velocity(max_velocity)
	legs.set_accel_time(accel_time)
	legs.set_decel_time(decel_time)

	legs.set_direction(input_direction)
	pass

func check_for_new_state() -> String:
	if jump:
		return "Jump"
	if not sprint:
		return "Walk"
	if is_zero_approx(input_direction.length_squared()):
		return "Idle"
	return "Sprint"

func _set_input_direction(direction: Vector2) -> void:
	input_direction = direction
	legs.set_direction(direction)