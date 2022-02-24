extends Node

signal direction_changed(new_direction)

var current_move_objective: Vector3
onready var location_ref: Spatial = get_parent()

var last_frame_distance_squared: float

func update_current_objective(new_objective: Vector3) -> void:
	current_move_objective = new_objective
	
	if new_objective.is_equal_approx(Vector3.ZERO):
		emit_signal("direction_changed", Vector2.ZERO)
		return

	var current_vector2: Vector2 = Vector2(location_ref.global_transform.origin.x, location_ref.global_transform.origin.z)
	var target_vector2: Vector2 = Vector2(new_objective.x, new_objective.z)

	last_frame_distance_squared = current_vector2.distance_squared_to(target_vector2)

	emit_signal("direction_changed", current_vector2.direction_to(target_vector2))

func _physics_process(_delta: float) -> void:
	if current_move_objective.is_equal_approx(Vector3.ZERO):
		return

	var current_vector2: Vector2 = Vector2(location_ref.global_transform.origin.x, location_ref.global_transform.origin.z)
	var target_vector2: Vector2 = Vector2(current_move_objective.x, current_move_objective.z)

	if current_vector2.distance_squared_to(target_vector2) > last_frame_distance_squared:
		emit_signal("direction_changed", current_vector2.direction_to(target_vector2))
