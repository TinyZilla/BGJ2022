extends Node

# has a signal (Objective Updated)
# When Enemy spawns, it grabs an objective from the list.
# Enemy subscribes to the Objective signal.
# When Objective dies, it tells Objective list, then Objective list fires the signal.

var objective_list: Array = []

signal objective_updated(updated_location)

func get_current_objective() -> Vector3:
	if objective_list.empty():
		return Vector3.ZERO
	
	return objective_list.front()

func reset_objective_list(group_name: String) -> void:
	for node in get_tree().get_nodes_in_group(group_name):
		node.destoryed(true)

	objective_list.clear()

func ready_obj_group(group_name: String) -> void:
	for node in get_tree().get_nodes_in_group(group_name):
		node.add_to_objective()

func objective_added(location: Vector3) -> void:
	objective_list.append(location)

func objective_died() -> void:
	print("Next Obj")
	objective_list.pop_front()
	emit_signal("objective_updated", get_current_objective())

# For testing.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		objective_died()