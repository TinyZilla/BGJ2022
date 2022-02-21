extends Spatial


func _mouse_moved_y(pixel: float) -> void:
	rotation_degrees.x -= pixel * 0.2
	rotation_degrees.x = clamp(rotation_degrees.x, -89, 89)
