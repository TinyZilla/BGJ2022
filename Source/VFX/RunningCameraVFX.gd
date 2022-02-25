extends Spatial

export(NodePath) var movement_state_machine_path

onready var state_machine = get_node(movement_state_machine_path)

onready var particles = $Particles

func _process(_delta):
	if is_instance_valid(state_machine):
		var y_input : float = state_machine.state_list["Sprint"].input_direction.y
		particles.emitting = state_machine.current_state == "Sprint" and y_input < 0.0
	else:
		state_machine = get_node(movement_state_machine_path)
