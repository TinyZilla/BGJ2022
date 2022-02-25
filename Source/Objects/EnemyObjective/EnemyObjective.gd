extends Spatial

var fall_location: Vector3

export(String) var group = "objective_stage_1"

const death_vfx = preload("res://Source/VFX/EnemyDeathVFX.tscn")

var is_alive: bool = false

func _enter_tree() -> void:
	fall_location = global_transform.origin
	add_to_group(group)

func destoryed(by_global: bool = false) -> void:
	is_alive = false
	if not by_global:
		EnemyObjectiveList.objective_died()

	var dfx = death_vfx.instance()
	get_tree().current_scene.add_child(dfx)
	dfx.global_transform = global_transform

	global_transform.origin = SkyfallManager.cluster_start_location

func _ready() -> void:
	global_transform.origin = SkyfallManager.cluster_start_location

func add_to_objective() -> void:
	EnemyObjectiveList.objective_added(fall_location)
	is_alive = true