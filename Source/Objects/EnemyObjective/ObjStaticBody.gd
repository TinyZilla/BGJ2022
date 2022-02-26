extends StaticBody

func hurt(damage: float) -> void:
	get_parent().hurt(damage)
