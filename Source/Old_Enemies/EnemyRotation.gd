extends Spatial

var do_rotate: bool = false
var angle: float = PI/2

func direction_changed(incoming_direction: Vector2) -> void:
	if incoming_direction.is_equal_approx(Vector2.ZERO):
		do_rotate = false
		return
	
	angle = Vector2(incoming_direction.x, -incoming_direction.y).angle()
	do_rotate = true

func _physics_process(_delta: float) -> void:
	if not do_rotate:
		return
	
	rotation.y = lerp_angle(rotation.y, angle - PI/2, 0.05)
