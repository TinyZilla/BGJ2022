extends Node

# Wave Manager. (Global)
# Has a Counter for Enemy Count
# When Enemy spawns, it first check in with the Wave Manager.
# When Enemy dies, it tells Wave Manager it dies
# Emit a Signal When Wave Ends. (All Enemies Died.)
# Emit a signal when enemy dies, With the remaining count left.

signal enemy_died(remaining)

var _current_enemy_count: int = 0

func add_enemy() -> void:
	_current_enemy_count += 1

func remove_enemy() -> void:
	_current_enemy_count -= 1
	emit_signal("enemy_died", _current_enemy_count)