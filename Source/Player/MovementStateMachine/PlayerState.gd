extends State

var legs: Node

var input_direction: Vector2 = Vector2.ZERO setget _set_input_direction
var jump: bool = false setget _set_jump
var sprint: bool = false

func enter(init_arg: Dictionary = {}) -> void:
	# print(name)
	# Tiny can uncomment this^^ bastard statement later,
	# rn its driving me nuts

	input_direction = init_arg.get("input_direction", Vector2.ZERO)
	jump = init_arg.get("jump", false)
	sprint = init_arg.get("sprint", false)
	pass

func exit() -> Dictionary:
	return {
		"input_direction": input_direction,
		"jump": jump,
		"sprint": sprint
	}

func _set_input_direction(direction: Vector2) -> void:
	input_direction = direction

func _set_jump(_jump: bool) -> void:
	jump = _jump
