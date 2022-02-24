extends Camera

func _enter_tree() -> void:
	StateTransitionManager.overhead_cam = self