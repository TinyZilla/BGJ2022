extends KinematicBody

var velocity : Vector3 # Set by instancer
var old_pos : Vector3

const DAMAGE = 1
const blood_splatter = preload("res://Source/VFX/BloodSplatter.tscn")
const bullet_pop = preload("res://Source/VFX/BulletPop.tscn")

func _ready():
	old_pos = global_transform.origin
	var _error = get_tree().create_timer(5).connect("timeout", self, "sudoku")

func _physics_process(_delta):
	# warning-ignore:return_value_discarded
	move_and_slide(velocity)
	old_pos = global_transform.origin
	_check_collision()

func _check_collision() -> void:
	var space_state = get_world().direct_space_state
	var curr_pos = global_transform.origin
	
	var intersection = space_state.intersect_ray(old_pos, curr_pos, [], 1)
	
	if (not intersection.empty()):
		var pos = intersection.position
		var normal = intersection.normal
		hit()
		sudoku()
		return
	
	var slide_count : int = get_slide_count()
	if slide_count > 0:
		for i in range(slide_count):
			var collision : KinematicCollision = get_slide_collision(i)
			var collider = collision.collider
			if collider is Enemy:
				collider.hurt(DAMAGE)
				blood_hit()
			else:
				hit()
		sudoku()

func blood_hit():
	var bs = blood_splatter.instance()
	get_tree().current_scene.add_child(bs)
	bs.global_transform.origin = global_transform.origin

func hit():
	var bp = bullet_pop.instance()
	get_tree().current_scene.add_child(bp)
	bp.global_transform.origin = global_transform.origin

func sudoku():
	queue_free()
