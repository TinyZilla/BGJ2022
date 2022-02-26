extends Node

signal current_move_target_updated(new_target)
signal current_objective_updated(new_objective)

var location_ref: Spatial
var player_ref: Spatial

var last_seen_player: Vector3

var current_path: Array = []
var current_index: int = 0

var following_path: bool = false
var arrived: bool = false

var chase_state: bool = false

var pause_timer: float = 5.0

func _ready() -> void:
	location_ref = get_parent()
	player_ref = Globals.player

func _physics_process(delta: float) -> void:

	# Scan to see if I can see the player.
	var space_state = location_ref.get_world().direct_space_state
	var intersection = space_state.intersect_ray(
		location_ref.get_node("Body/BodyshotPosition").global_transform.origin,
		player_ref.get_node("Body/BodyshotPosition").global_transform.origin,
		[], 3)
	
	if not intersection.empty() and intersection.collider is Player:
		last_seen_player = intersection.position
		chase_state = true
		following_path = false
	else:
		if chase_state:
			emit_signal("current_move_target_updated", Vector3.ZERO)
			emit_signal("current_objective_updated", Vector3.ZERO)
		chase_state = false

	if chase_state:
		emit_signal("current_move_target_updated", last_seen_player)
		emit_signal("current_objective_updated", last_seen_player)
		return
	
	if not following_path:
		current_path = Globals.navigation.get_simple_path(
			location_ref.global_transform.origin,
			last_seen_player if not arrived else player_ref.global_transform.origin)
		current_index = 0
		following_path = true
		arrived = false
	
	if arrived or current_path.empty():
		if pause_timer > 0.0:
			pause_timer -= delta
		else:
			following_path = false
		return
	
	var current_location: Vector3 = location_ref.global_transform.origin
	var current_target: Vector3 = current_path[current_index]

	# Check if I am close nuff to the current checkpoint.
	if current_location.distance_squared_to(current_target) < 4:
		current_index += 1
		
		if current_index == current_path.size():
			arrived = true
			pause_timer = 5.0
			emit_signal("current_move_target_updated", Vector3.ZERO)
			return
		
		emit_signal("current_move_target_updated", current_path[current_index])
