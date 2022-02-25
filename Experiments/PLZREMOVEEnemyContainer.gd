extends Spatial

func _enter_tree() -> void:
	WaveManager.enemy_container = self

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		get_child(0).call_deferred("queue_free")
	if event.is_action_pressed("ui_left"):
		WaveManager.terminate_wave_early()