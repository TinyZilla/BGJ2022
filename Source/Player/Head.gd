extends Spatial


func _mouse_moved_y(pixel: float) -> void:
	rotation_degrees.x -= pixel * Globals.mouse_sensitivity
	rotation_degrees.x = clamp(rotation_degrees.x, -89, 89)
