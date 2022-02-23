extends Spatial

export(float) var BULLET_SPEED = 30.0
export(NodePath) var camera_path

onready var camera : Camera = get_node(camera_path)

const bullet_scene = preload("res://Source/Bullet/Bullet.tscn")

func instance_bullet() -> void:
	if not is_instance_valid(camera):
		camera = get_node(camera_path)
	
	var b = bullet_scene.instance()
	get_tree().current_scene.add_child(b)
	b.global_transform.origin = global_transform.origin
	var velocity : Vector3 = Vector3.FORWARD
	velocity = velocity.rotated(Vector3.UP, global_transform.basis.get_euler().y)
	velocity = velocity.rotated(global_transform.basis.x, camera.global_transform.basis.get_euler().x)
	velocity *= BULLET_SPEED
	b.velocity = velocity
	
	# Orientation
	var forward_point : Vector3 = global_transform.origin - global_transform.basis.z
	forward_point = global_transform.origin + velocity.normalized()
	b.look_at(forward_point, Vector3.UP)
