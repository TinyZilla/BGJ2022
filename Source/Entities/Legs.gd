extends Node

# ----------------------------------------------
#                Signals
# ----------------------------------------------
signal landed
# ----------------------------------------------
#                Variables
# ----------------------------------------------

# Horizontal Variables.
export(float) var _max_velocity: float = 10.0 setget set_max_velocity # Meters per second
export(float) var _accel_time: float = 0.2 setget set_accel_time # Seconds
export(float) var _decel_time: float = 0.4 setget set_decel_time # Seconds

# Vertical Variables.
export(float) var _jump_height: float = 3.0 setget set_jump_height # meters.
export(float) var _jump_time_to_peak: float = 0.3 setget set_jump_time_to_peak # Seconds
export(float) var _jump_time_to_ground: float = 0.4 setget set_jump_time_to_ground # Seconds

# Public facing Variable. Could be updated.
var _direction: Vector2 = Vector2.ZERO
var _jump_input: bool = false

# Used by the class, Not updated.
var _velocity: Vector3 = Vector3.ZERO
var _kinematic_body: KinematicBody

var _landed: bool = true

# for horizontal calculations
var _accel: float
var _friction: float

# for jumping calculations
var _jump_velocity: float
var _jump_gravity: float
var _fall_gravity: float

# ----------------------------------------------
#                Public Functions
# ----------------------------------------------

func set_direction(direction: Vector2) -> void:

	_direction = direction.normalized()
	# Maybe do some Direction check and velocity cancel here?

	var local_velocity: Vector3 = _global_to_local(_velocity)

	if sign(_direction.x) * sign(local_velocity.x) == -1:
		_velocity.x = local_velocity.x * 0.1
	if sign(_direction.y) * sign(local_velocity.z) == -1:
		_velocity.z = local_velocity.z * 0.1
	
	_velocity = _local_to_global(local_velocity)

# TMP
# Todo. Coytote time.
func jump(jump: bool) -> void:
	_jump_input = jump

	if not _jump_input or not _kinematic_body.is_on_floor():
		return
	_jump()

# ----------------------------------------------
#          Public Param Change Functions
# ----------------------------------------------
func set_max_velocity(velocity: float) -> void:
	_max_velocity = velocity
	_move_variable_calculation()

func set_accel_time(time: float) -> void:
	_accel_time = time
	_move_variable_calculation()

func set_decel_time(time: float) -> void:
	_decel_time = time
	_move_variable_calculation()

func set_jump_height(jump_height: float) -> void:
	_jump_height = jump_height
	_jump_variable_calculation()

func set_jump_time_to_peak(time_to_peak: float) -> void:
	_jump_time_to_peak = time_to_peak
	_jump_variable_calculation()

func set_jump_time_to_ground(time_to_ground: float) -> void:
	_jump_time_to_ground = time_to_ground
	_jump_variable_calculation()

# ----------------------------------------------
#                Private Functions
# ----------------------------------------------
func _ready() -> void:
	_kinematic_body = get_parent()

	_move_variable_calculation()
	_jump_variable_calculation()

func _move_variable_calculation() -> void:
	_accel = _max_velocity / _accel_time
	_friction = _max_velocity / _decel_time

func _jump_variable_calculation() -> void:
	_jump_velocity = (2.0 * _jump_height) / _jump_time_to_peak
	_jump_gravity = (-2.0 * _jump_height) / (_jump_time_to_peak * _jump_time_to_peak)
	_fall_gravity = (-2.0 * _jump_height) / (_jump_time_to_ground * _jump_time_to_ground)

func _physics_process(delta: float) -> void:
	_floor_movement(delta)
	_air_movement(delta)

	_velocity = _kinematic_body.move_and_slide(_velocity, Vector3.UP)

	_check_jump_buffer()

func _jump() -> void:
	_velocity.y = _jump_velocity

	_landed = false

func _air_movement(delta: float) -> void:
	var gravity: float = _jump_gravity if _velocity.y > 0 else _fall_gravity
	_velocity.y += gravity * delta

func _floor_movement(delta: float) -> void:
	_decel_floor(delta)
	_accel_floor(delta)

func _accel_floor(delta: float) -> void:
	if is_zero_approx(_direction.length_squared()):
		return

	var local_velocity: Vector3 = _global_to_local(_velocity)

	# Move everything to Vec2 for the calculation.
	var mapped_velocity: Vector2 = Vector2(local_velocity.x, local_velocity.z)

	mapped_velocity += _direction * _accel * delta
	mapped_velocity = mapped_velocity.clamped(_max_velocity)

	# Move everything back to the Vector3.
	local_velocity.x = mapped_velocity.x
	local_velocity.z = mapped_velocity.y

	_velocity = _local_to_global(local_velocity)

func _decel_floor(delta: float) -> void:
	if !is_zero_approx(_direction.x) and !is_zero_approx(_direction.y):
		return

	var local_velocity: Vector3 = _global_to_local(_velocity)
	
	var friction_calc: float = _friction * delta
	var ground_velocity: Vector2 = Vector2(local_velocity.x, local_velocity.z)
	var friction_amount: Vector2 = ground_velocity.normalized() * friction_calc

	# If only apply deceleration to the part that needs it.
	if is_zero_approx(_direction.x):
		if abs(local_velocity.x) > friction_calc * friction_calc:
			local_velocity.x -= friction_amount.x
		else:
			local_velocity.x = 0

	if is_zero_approx(_direction.y):
		if abs(local_velocity.z) > friction_calc * friction_calc:
			local_velocity.z -= friction_amount.y
		else:
			local_velocity.z = 0
	
	_velocity = _local_to_global(local_velocity)

func _check_jump_buffer() -> void:
	if not _landed and _kinematic_body.is_on_floor():
		_landed = true
		emit_signal("landed")

		if _jump_input:
			_jump()

# ----------------------------------------------
#                Helper Functions
# ----------------------------------------------
# These two are needed to transform the axis to match the player facing axis.
# I have no fking clue why this works, and why is it different from `to_local` or `to_global`
func _local_to_global(velocity: Vector3) -> Vector3:
	return _kinematic_body.global_transform.basis.xform(velocity)

func _global_to_local(velocity: Vector3) -> Vector3:
	return _kinematic_body.global_transform.basis.xform_inv(velocity)
