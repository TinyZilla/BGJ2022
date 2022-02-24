extends Node

onready var _body: KinematicBody
onready var sight_raycast = $PlayerSightRayCast

onready var nav: Navigation
onready var player: Spatial

var path: PoolVector3Array
var current_index: int
var current_target: Vector3

var prev_distance_squared: float

var do_pathfind_process : bool = true # Replace with state change later

signal direction_changed(direction)
signal sprint_changed(pressed)

func enter(target_position : Vector3 = Vector3.ZERO) -> void:
	var state_machine = get_parent()
	_body = state_machine._body
	player = state_machine.player
	nav = state_machine.nav
	
	sight_raycast.enabled = true
	current_target = target_position
	
	init_pathfinding()

func check_valid_nodes():
	# Band-aid fix function
	var state_machine = get_parent()
	if not is_instance_valid(_body):
		_body = state_machine._body
	if not is_instance_valid(player):
		player = state_machine.player
	if not is_instance_valid(nav):
		nav = state_machine.nav

func do_state_logic(_delta : float) -> void:
	check_valid_nodes()
	process_pathfinding()

func init_pathfinding():	
	path = nav.get_simple_path(_body.global_transform.origin, current_target) # player.global_transform.origin)
	current_index = 0
	current_target = path[current_index]
	
	var origin_vector2: Vector2 = Vector2(_body.global_transform.origin.x, _body.global_transform.origin.z)
	var target_vector2: Vector2 = Vector2(current_target.x, current_target.z)
	
	prev_distance_squared = origin_vector2.distance_squared_to(target_vector2)

	do_pathfind_process = true
	
	emit_signal("direction_changed", origin_vector2.direction_to(target_vector2))

func process_pathfinding():
	if not do_pathfind_process:
		return
	if !is_instance_valid(_body) or !is_instance_valid(player) or !is_instance_valid(nav):
		return
	
	var origin_vector2: Vector2 = Vector2(_body.global_transform.origin.x, _body.global_transform.origin.z)
	var target_vector2: Vector2 = Vector2(current_target.x, current_target.z)
	
	# Check if I am getting close to my target point.
	if origin_vector2.distance_squared_to(target_vector2) < 2:
		current_index += 1
		
		if current_index == path.size():
			emit_signal("direction_changed", Vector2.ZERO)
			do_pathfind_process = false

			_band_aid()
			return
		
		current_target = path[current_index]
		
		prev_distance_squared = _body.global_transform.origin.distance_squared_to(current_target)
		
		origin_vector2 = Vector2(_body.global_transform.origin.x, _body.global_transform.origin.z)
		target_vector2 = Vector2(current_target.x, current_target.z)
		
		emit_signal("direction_changed", origin_vector2.direction_to(target_vector2))
	
	if origin_vector2.distance_squared_to(target_vector2) >= prev_distance_squared:
		origin_vector2 = Vector2(_body.global_transform.origin.x, _body.global_transform.origin.z)
		target_vector2 = Vector2(current_target.x, current_target.z)
		
		emit_signal("direction_changed", origin_vector2.direction_to(target_vector2))

func exit():
	sight_raycast.enabled = false

func check_for_new_state() -> String:
	check_valid_nodes()
	
	if not is_instance_valid(player):
		return "PathfindTarget"
	
	sight_raycast.global_transform.origin = _body.bodyshot_position.global_transform.origin
	sight_raycast.cast_to = sight_raycast.to_local(player.bodyshot_position.global_transform.origin)
	if sight_raycast.is_colliding():
		var collider = sight_raycast.get_collider()
		if collider is Player:
			return "Chase"
	return "PathfindTarget"

func _band_aid() -> void:
	yield(get_tree().create_timer(2.0), "timeout")
	enter(player.global_transform.origin)
