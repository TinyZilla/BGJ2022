extends Camera

func _enter_tree() -> void:
	StateTransitionManager.player_cam = self