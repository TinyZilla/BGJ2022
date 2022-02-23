extends Node

var current_state = "PathfindTarget"

onready var state_list = \
{
	"PathfindTarget" : get_node("PathfindTarget")
}

func _ready():
	state_list[current_state].enter()

# Update function.
func _physics_process(delta: float) -> void:
	state_list[current_state].do_state_logic(delta)
