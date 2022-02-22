extends KinematicBody

var velocity : Vector3 # Set by instancer
var old_pos : Vector3

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
		sudoku()
		return
	
	if get_slide_count() > 1:
		sudoku()

func sudoku():
	queue_free()
