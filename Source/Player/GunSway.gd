extends Spatial

export(float) var mouse_damp = 0.3
export(float) var lissajous_strength = 0.03
export(float) var lissajous_speed = 15.0
export(Vector2) var lissajous_ratio = Vector2(1, 2)
export(float) var return_speed = 3.0

var mouse_movement := Vector2.ZERO
var x_lag : float = 0.0
var initial_transform : Transform
var time_since_move : float = 0.0

func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement = lerp(mouse_movement, -event.relative * mouse_damp, 0.5)
		mouse_movement = -event.relative * mouse_damp

# Apply rotation transforms in this order: Y, X, Z
# Apply origin transform AFTER rotations

# Lissajous curves for position
# x = sin(at + delta)
# y = sin(bt)
# Where delta = PI / 2.0, a = 1.0, b = 2.0

func _ready():
	initial_transform = transform

# ----------------------------------------------
#      THIS IS FUCKING BROKEN TO ALL HELL
# ----------------------------------------------
func cm(n, multiple) -> float:
	var lower_limit : float = floor(n / multiple) * multiple
	var upper_limit : float = ceil(n / multiple) * multiple
	if abs(upper_limit - n) < abs(lower_limit - n):
		return upper_limit
	else:
		return lower_limit
func ls_wrap(n):
	var snap : float = stepify(n, PI / 2.0)
	# snap is of type k * (PI / 2.0)
	# where k is an integer constant
	# We must make sure k is odd
	var coefficient : int = int(snap / (PI / 2.0))
	if not bool(coefficient % 2):
		coefficient += 1
	return float(coefficient) * (PI / 2.0)

func lissajous(t : float, ratio : Vector2, delta : float) -> Vector2:
	var l := Vector2.ZERO
	l.x = sin(ratio.x * t + delta)
	l.y = sin(ratio.y * t)
	return l

func _physics_process(delta):
	# Setup transform, input_direction and time elapsed since moving
	var t := Transform()
	var input_direction := Vector2.ZERO
	input_direction.x = Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")
	input_direction.y = Input.get_action_strength("movement_down") - Input.get_action_strength("movement_up")
	input_direction = input_direction.normalized()
	
	# Rotate local transform
	t = t.rotated(Vector3.UP, deg2rad(-mouse_movement.x))
	t = t.rotated(t.xform(Vector3.RIGHT), deg2rad(-mouse_movement.y))
	var x_input : float = input_direction.x
	x_input *= 10.0
	x_lag = lerp(x_lag, x_input, 0.3)
	t = t.rotated(t.xform(Vector3.FORWARD), deg2rad(x_lag))
	
	# Apply Lissajous curves
	if input_direction.length() > 0.0:
		time_since_move += delta
		time_since_move = fmod(time_since_move, PI)
		var new_origin = initial_transform.origin
		var parameter = time_since_move * lissajous_speed
		var l = lissajous(parameter, lissajous_ratio, PI / 2.0)
		new_origin.x += l.x * lissajous_strength
		new_origin.y += l.y * lissajous_strength
		t.origin = translation.linear_interpolate(new_origin, 0.4)
	else:
		t.origin = translation.linear_interpolate(initial_transform.origin, 0.2)
	
	transform = t
	mouse_movement = lerp(mouse_movement, Vector2.ZERO, 0.4)
