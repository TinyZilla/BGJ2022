extends Node

var current_state = "PathfindTarget"
var _body : KinematicBody
var player : Spatial
var nav : Navigation

onready var state_list = \
{
	"PathfindTarget" : get_node("PathfindTarget"),
	"Chase" : get_node("Chase")
}

func _ready():
	state_list[current_state].call_deferred("enter")

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
