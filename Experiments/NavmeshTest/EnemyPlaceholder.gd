extends KinematicBody

export(float) var MAX_SPEED = 5.0
# Tiny's gonna kill me for that ^^^

func _move(point : Vector3):
	var current_pos : Vector3 = global_transform.origin
	var direction : Vector3 = current_pos.direction_to(point)
	
	# warning-ignore:return_value_discarded
	move_and_slide(direction * MAX_SPEED, Vector3.UP)

