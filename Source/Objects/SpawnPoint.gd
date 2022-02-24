extends Spatial

func _enter_tree() -> void:
	EnemySpawner.add_spawn_point(global_transform.origin)