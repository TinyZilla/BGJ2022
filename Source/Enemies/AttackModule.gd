extends Spatial

export(float) var damage: float = 10.0
export(float) var atk_cooldown: float = 1.5

onready var location_ref: Spatial = get_owner()
var current_attack_objective: Vector3

var is_attacking: bool = false

func update_objective(objective: Vector3) -> void:
	current_attack_objective = objective

func attack() -> void:
	is_attacking = true
	for body in $Area.get_overlapping_bodies():
		if body.has_method("hurt"):
			body.hurt(damage)

	var _t = get_tree().create_timer(atk_cooldown).connect("timeout", self, "reset_attack")
	
func reset_attack() -> void:
	is_attacking = false

func _physics_process(_delta: float) -> void:
	if is_attacking or current_attack_objective.is_equal_approx(Vector3.ZERO):
		return
	
	var current_vector2: Vector2 = Vector2(location_ref.global_transform.origin.x, location_ref.global_transform.origin.z)
	var target_vector2: Vector2 = Vector2(current_attack_objective.x, current_attack_objective.z)

	if current_vector2.distance_squared_to(target_vector2) < 4:
		# Trigger Attack Animation
		attack()
