extends KinematicBody
class_name Player

signal player_active_changed(is_enable)

onready var bodyshot_position = $Body/BodyshotPosition

var player_gun: Spatial
var player_brain: Node

export(float) var MAX_HEALTH = 20.0
var health : float = MAX_HEALTH

const hurt_sfx := [
	preload("res://Audio/SFX/Player_Pain1.wav"),
	preload("res://Audio/SFX/Player_Pain2.wav"),
	preload("res://Audio/SFX/Player_Pain3.wav"),
]

func _enter_tree() -> void:
	Globals.player = self
	StateTransitionManager.player = self
	health = MAX_HEALTH

func disable() -> void:
	player_gun.disable()
	player_brain.disable()
	emit_signal("player_active_changed", false)

func enable() -> void:
	player_gun.enable()
	player_brain.enable()
	health = MAX_HEALTH
	emit_signal("player_active_changed", true)

func _mouse_moved_x(pixel: float) -> void:
	rotation_degrees.y -= pixel * Globals.mouse_sensitivity

func hurt(damage: float) -> void:
	health -= damage
	health = clamp(health, 0.0, MAX_HEALTH)
	
	var stream = hurt_sfx[randi()%hurt_sfx.size()]
	AudioManager.play_sfx(stream, "SFX", -10.0)
	
	if is_zero_approx(health):
		WaveManager.terminate_wave_early()
