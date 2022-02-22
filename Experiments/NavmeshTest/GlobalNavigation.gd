extends Navigation
class_name GlobalNavigation

onready var click_placer = $CameraClickPlacer
onready var enemy = $EnemyPlaceholder

var path_idx : int = 0
var points_pool : PoolVector3Array

func _process(delta):
	if Input.is_action_just_pressed("LMB"):
		var pos = click_placer.click_3d()
		if pos:
			points_pool = get_simple_path(enemy.global_transform.origin, pos)
			path_idx = 0
	
	enemy._move(get_closest_path_point(enemy.global_transform.origin))

func get_closest_path_point(current_pos : Vector3):
	if not points_pool:
		return current_pos
	
	if path_idx < points_pool.size():
		var direction : Vector3 = points_pool[path_idx] - current_pos
		var pos : Vector3 = points_pool[path_idx]
		if direction.length() < 1.0:
			path_idx += 1
		return pos
	return points_pool[points_pool.size() - 1]
