extends Node

export(NodePath) var legs_path: NodePath

var current_state = "Idle"

onready var state_list = \
{
	"Idle": get_node("Idle"),
	"Walk": get_node("Walk"),
	"Sprint": get_node("Sprint"),
	"Jump": get_node("Jump"),
}

# Setup for the state machine.
func _ready() -> void:
	assert(not legs_path.is_empty(), "Need a reference to legs.")
	
	var legs: Node = get_node(legs_path)
	# Getting the States Ready.
	for key in state_list.keys():
		state_list[key].legs = legs
	
	yield(legs, "ready")
	
	state_list[current_state].enter()

# Update function.
func _physics_process(delta: float) -> void:
	state_list[current_state].do_state_logic(delta)
	try_state_transition()

# State Transition Handling.
func try_state_transition():
	var next_state = state_list[current_state].check_for_new_state()
	
	# Assertion Make sure everything runs smoothly.
	assert(state_list.keys().has(next_state))
	
	if next_state != current_state:
		var init_arg = state_list[current_state].exit()
		state_list[next_state].enter(init_arg)
		current_state = next_state

# ---------------------------------------------------
#     Input Triggers. Pass them onto the States.
# ---------------------------------------------------

# This is a dumb idea btw. But Prototype so fk it.
# A Smarter Idea is to probs have a reference to the brain. 
# And dynamically Connect the signals to the current active state.

func input_direction_changed(input_direction: Vector2) -> void:
	state_list[current_state].input_direction = input_direction
	# for key in state_list.keys():
	# 	state_list[key].input_direction = input_direction

func jump_changed(jump: bool) -> void:
	state_list[current_state].jump = jump
	# for key in state_list.keys():
	# 	state_list[key].jump = jump

func sprint_changed(sprint: bool) -> void:	
	state_list[current_state].sprint = sprint
	# for key in state_list.keys():
	# 	state_list[key].sprint = sprint
