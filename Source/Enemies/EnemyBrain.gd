extends Node

onready var _body: KinematicBody = get_parent()
var nav: Navigation
var player: Spatial

var path: PoolVector3Array
var current_index: int
var current_target: Vector3

var prev_distance_squared: float

signal direction_changed(direction)
signal sprint_changed(pressed)

func _ready() -> void:
	yield(get_tree().create_timer(2.0), "timeout")

	path = nav.get_simple_path(_body.global_transform.origin, Vector3.ZERO)
	print(path)
	current_index = 0
	current_target = path[current_index]

	var origin_vector2: Vector2 = Vector2(_body.global_transform.origin.x, _body.global_transform.origin.z)
	var target_vector2: Vector2 = Vector2(current_target.x, current_target.z)

	prev_distance_squared = origin_vector2.distance_squared_to(target_vector2)

	emit_signal("direction_changed", origin_vector2.direction_to(target_vector2))

func _physics_process(_delta: float) -> void:

	var origin_vector2: Vector2 = Vector2(_body.global_transform.origin.x, _body.global_transform.origin.z)
	var target_vector2: Vector2 = Vector2(current_target.x, current_target.z)

	# Check if I am getting close to my target point.
	if origin_vector2.distance_squared_to(target_vector2) < 2:
		print(origin_vector2.distance_squared_to(target_vector2))

		current_index += 1

		if current_index == path.size():
			print("finish")
			emit_signal("direction_changed", Vector2.ZERO)
			set_physics_process(false)
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
