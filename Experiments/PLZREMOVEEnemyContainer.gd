extends Spatial

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		get_child(0).call_deferred("queue_free")