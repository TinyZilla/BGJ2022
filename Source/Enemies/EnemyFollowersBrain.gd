extends Node

signal current_move_target_updated(new_target)
signal current_objective_updated(new_objective)

var current_obj: Vector3 = Vector3.ZERO setget set_current_obj
var location_ref: Spatial

var current_path: Array = []
var current_index: int = 0

var arrived: bool = false

func _ready() -> void:
	location_ref = get_parent() 

	var _t = EnemyObjectiveList.connect("objective_updated", self, "set_current_obj")
	call_deferred("set_current_obj", EnemyObjectiveList.get_current_objective())

func set_current_obj(global_position: Vector3) -> void:
	current_path = Globals.navigation.get_simple_path(location_ref.global_transform.origin, global_position)
	current_index = 0
	arrived = false

	emit_signal("current_objective_updated", global_position)

	if not current_path.empty():
		emit_signal("current_move_target_updated", current_path[current_index])

func _physics_process(_delta: float) -> void:
	if arrived or current_path.empty():
		return
	
	var current_location: Vector3 = location_ref.global_transform.origin
	var current_target: Vector3 = current_path[current_index]

	# Check if I am close nuff to the current checkpoint.
	if current_location.distance_squared_to(current_target) < 4:
		current_index += 1
		
		if current_index == current_path.size():
			arrived = true
			emit_signal("current_move_target_updated", Vector3.ZERO)
			return
		
		emit_signal("current_move_target_updated", current_path[current_index])
