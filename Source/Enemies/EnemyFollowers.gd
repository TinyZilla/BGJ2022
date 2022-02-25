extends KinematicBody
class_name Enemy # Can swap this out for groups instead too

export(float) var MAX_HEALTH = 4.0

var health : float = MAX_HEALTH

func _enter_tree() -> void:
	WaveManager.add_enemy()
	health = MAX_HEALTH

func _exit_tree() -> void:
	WaveManager.remove_enemy()

func hurt(damage : float) -> void:
	health -= damage
	health = clamp(health, 0.0, MAX_HEALTH)
	
	if health == 0.0:
		queue_free()
