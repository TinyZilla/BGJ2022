extends KinematicBody

func _mouse_moved_x(pixel: float) -> void:
	rotation_degrees.y -= pixel * 0.2
