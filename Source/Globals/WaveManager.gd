extends Node

# Wave Manager. (Global)
# Has a Counter for Enemy Count
# When Enemy spawns, it first check in with the Wave Manager.
# When Enemy dies, it tells Wave Manager it dies
# Emit a Signal When Wave Ends. (All Enemies Died.)
# Emit a signal when enemy dies, With the remaining count left.

signal wave_ended

var end_wave_at: int = 0
var _current_enemy_count: int = 0

var enemy_container: Spatial

var reset: bool = false

func terminate_wave_early() -> void:
	reset = true

	for child in enemy_container.get_children():
		child.queue_free()

	call_deferred("emit_signal", "wave_ended")

func ready_wave() -> void:
	reset = false

func add_enemy() -> void:
	_current_enemy_count += 1

func remove_enemy() -> void:
	_current_enemy_count -= 1
	_check_if_end_wave()

func _check_if_end_wave() -> void:
	if _current_enemy_count == end_wave_at:
		emit_signal("wave_ended")

func spawn_wave(wave_data: Dictionary) -> void:
	end_wave_at = wave_data.get("next_event_trigger_at", 0)

	var enemies: Dictionary = wave_data.get("enemies", {})

	var enemy_array: Array = []

	for key in enemies.keys():
		for _i in range(enemies.get(key)):
			enemy_array.append(key)

	enemy_array.shuffle()

	for enemy in enemy_array:
		EnemySpawner.spawn(enemy)
		
		yield(get_tree().create_timer(1), "timeout")

		if reset:
			break
