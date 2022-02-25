extends KinematicBody

func _enter_tree() -> void:
	WaveManager.add_enemy()

func _exit_tree() -> void:
	WaveManager.remove_enemy()
