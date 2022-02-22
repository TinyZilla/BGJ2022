extends Spatial

export(float) var BULLET_SPEED = 30.0

const bullet_scene = preload("res://Source/Bullet/Bullet.tscn")

func _physics_process(_delta):
	if Input.is_action_just_pressed("LMB"):
		instance_bullet()

func instance_bullet() -> void:
	var b = bullet_scene.instance()
	get_tree().current_scene.add_child(b)
	b.global_transform.origin = global_transform.origin
	b.velocity = -global_transform.basis.z * BULLET_SPEED
	
	# Orientation
	var forward_point : Vector3 = global_transform.origin - global_transform.basis.z
	b.look_at(forward_point, Vector3.UP)
