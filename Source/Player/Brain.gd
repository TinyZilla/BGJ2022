extends Node

# ----------------------------------------------
#                Variable
# ----------------------------------------------

# ----------------------------------------------
#                Signals
# ----------------------------------------------
signal input_direction_changed(input_direction)
signal jump_changed(pressed)
signal mouse_moved_x(pixel)
signal mouse_moved_y(pixel)

# ----------------------------------------------
#                Private Functions
# ----------------------------------------------

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	_check_movement_input(event)
	_check_jump_input(event)
	_check_look_input(event)

func _check_look_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return
	
	# Programmer's note. The X and Y values are pixel value on the screen.
	
	if not is_zero_approx(event.relative.x):
		emit_signal("mouse_moved_x", event.relative.x)
	
	if not is_zero_approx(event.relative.y):
		emit_signal("mouse_moved_y", event.relative.y)

func _check_movement_input(event: InputEvent) -> void:
	if event.is_echo() or !event.is_action("movement_left") and !event.is_action("movement_right") \
		and !event.is_action("movement_up") and !event.is_action("movement_down"):
		return

	var input_direction = Vector2(
		Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left"),
		Input.get_action_strength("movement_down") - Input.get_action_strength("movement_up")
		)
	
	emit_signal("input_direction_changed", input_direction)

func _check_jump_input(event: InputEvent) -> void:
	if event.is_echo() or !event.is_action("movement_jump"):
		return

	emit_signal("jump_changed", event.is_pressed())
	
