extends StaticBody

var fall_location: Vector3

export(String) var group = "default"

func _enter_tree() -> void:
	fall_location = global_transform.origin
	add_to_group(group)

func _ready() -> void:
	global_transform.origin = SkyfallManager.cluster_start_location
