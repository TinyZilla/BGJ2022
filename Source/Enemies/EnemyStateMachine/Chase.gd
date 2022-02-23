extends Node

signal direction_changed(new_direction)

onready var sight_raycast = $PlayerSightRayCast

var _body : KinematicBody
var player : Spatial
var last_known_position : Vector3

func enter(_init_arg = null) -> void:
	var state_machine = get_parent()
	player = state_machine.player
	_body = state_machine._body
	
	sight_raycast.enabled = true

func do_state_logic(delta : float) -> void:
	sight_raycast.global_transform.origin = _body.bodyshot_position.global_transform.origin
	sight_raycast.cast_to = sight_raycast.to_local(player.bodyshot_position.global_transform.origin)
	
	if sight_raycast.is_colliding():
		var collider = sight_raycast.get_collider()
		if collider is Player:
			# Keep Personal Space. Covid. Watch out!
			if sight_raycast.global_transform.origin.distance_squared_to(sight_raycast.get_collision_point()) < 4:
				emit_signal("direction_changed", Vector2.ZERO)
				return
			
			# Can see player, chase after that mf
			var origin_vector2 : Vector2 = Vector2(_body.global_transform.origin.x, _body.global_transform.origin.z)
			var target_vector2 : Vector2 = Vector2(player.global_transform.origin.x, player.global_transform.origin.z)
			var direction : Vector2 = origin_vector2.direction_to(target_vector2)
			
			last_known_position = collider.global_transform.origin
			
			emit_signal("direction_changed", direction)

func exit():
	sight_raycast.enabled = false
	return last_known_position

func check_for_new_state() -> String:
	if sight_raycast.is_colliding():
		var collider = sight_raycast.get_collider()
		if not collider is Player:
			return "PathfindTarget"
	return "Chase"
