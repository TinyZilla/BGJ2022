extends "res://Source/Player/MovementStateMachine/PlayerState.gd"

export(float) var max_velocity: float = 15.0
export(float) var accel_time: float = 0.15
export(float) var decel_time: float = 0.4
export(float) var footsteps_interval = 0.1

# Maybe add more limitation here so that you can only sprint forwards...
# You already did that ^^ dumbass

var footsteps_i : int = 0
const footsteps_sfx := [
	preload("res://Audio/SFX/Player_Footstep1.wav"),
	preload("res://Audio/SFX/Player_Footstep2.wav"),
]
onready var footsteps_timer = $Timer

func enter(init_arg: Dictionary = {}) -> void:
	.enter(init_arg)

	legs.set_max_velocity(max_velocity)
	legs.set_accel_time(accel_time)
	legs.set_decel_time(decel_time)

	legs.set_direction(input_direction)
	
	footsteps_timer.start(footsteps_interval)

func check_for_new_state() -> String:
	if jump:
		return "Jump"
	if not sprint or input_direction.y >= 0.0:
		return "Walk"
	if is_zero_approx(input_direction.length_squared()):
		return "Idle"
	return "Sprint"

func _set_input_direction(direction: Vector2) -> void:
	input_direction = direction
	legs.set_direction(direction)

func exit():
	footsteps_timer.stop()
	return .exit()

func play_footsteps_sfx():
	if footsteps_i > footsteps_sfx.size() - 1:
		footsteps_i = 0
	
	var stream = footsteps_sfx[footsteps_i]
	footsteps_i += 1
	AudioManager.play_sfx(stream, "SFX", -5.0)
