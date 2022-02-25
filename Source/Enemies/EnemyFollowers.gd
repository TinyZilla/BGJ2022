extends KinematicBody
class_name Enemy # Can swap this out for groups instead too

export(float) var MAX_HEALTH = 4.0

var health : float = MAX_HEALTH

const death_vfx = preload("res://Source/VFX/EnemyDeathVFX.tscn")

func _enter_tree() -> void:
	WaveManager.add_enemy()
	health = MAX_HEALTH

func _exit_tree() -> void:
	var dfx = death_vfx.instance()
	get_tree().current_scene.add_child(dfx)
	dfx.global_transform = global_transform

	WaveManager.remove_enemy()

func hurt(damage : float) -> void:
	health -= damage
	health = clamp(health, 0.0, MAX_HEALTH)
	
	if health == 0.0:
		queue_free()
