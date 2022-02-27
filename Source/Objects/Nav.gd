extends Navigation

var nav_stage_2: Resource = preload("res://Source/Levels/NavMeshes/navmesh-stage2.tres")

func _enter_tree() -> void:
	Globals.navigation = self

func swap_nav_mesh() -> void:
	$NavMeshInstance.set_navigation_mesh(nav_stage_2)