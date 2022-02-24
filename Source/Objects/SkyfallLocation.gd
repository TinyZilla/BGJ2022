extends Position3D


func _enter_tree() -> void:
	SkyfallManager.cluster_start_location = self.global_transform.origin