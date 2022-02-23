extends KinematicBody

func _ready() -> void:
	Globals.player = self

func _mouse_moved_x(pixel: float) -> void:
	rotation_degrees.y -= pixel * Globals.mouse_sensitivity
