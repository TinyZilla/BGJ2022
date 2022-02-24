extends Spatial

export(float) var BULLET_SPEED = 30.0
# Might replace with more automatic way to obtain camera
export(NodePath) var camera_path

onready var camera : Camera = get_node(camera_path)
onready var bullet_raycast = $BulletRayCast

const bullet_scene = preload("res://Source/Bullet/Bullet.tscn")

func _ready():
	bullet_raycast.set_as_toplevel(true)

func _process(_delta):
	bullet_raycast.global_transform = camera.global_transform
	bullet_raycast.cast_to = Vector3.FORWARD * 200.0

func instance_bullet() -> void:
	if not is_instance_valid(camera):
		camera = get_node(camera_path)
	
	var b = bullet_scene.instance()
	get_tree().current_scene.add_child(b)
	b.global_transform.origin = global_transform.origin
	
	var velocity : Vector3 = Vector3.ZERO
	
	if bullet_raycast.is_colliding():
		var point : Vector3 = bullet_raycast.get_collision_point()
		velocity = global_transform.origin.direction_to(point) * BULLET_SPEED
	else:
		var point : Vector3 = bullet_raycast.to_global(bullet_raycast.cast_to)
		velocity = global_transform.origin.direction_to(point) * BULLET_SPEED
	
	b.velocity = velocity
	
	# Orientation
	var forward_point : Vector3 = global_transform.origin - global_transform.basis.z
	forward_point = global_transform.origin + velocity.normalized()
	b.look_at(forward_point, Vector3.UP)
