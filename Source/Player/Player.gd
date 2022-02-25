extends KinematicBody
class_name Player

signal player_active_changed(is_enable)

onready var bodyshot_position = $Body/BodyshotPosition

var player_gun: Spatial
var player_brain: Node

func _enter_tree() -> void:
	Globals.player = self
	StateTransitionManager.player = self

func disable() -> void:
	player_gun.disable()
	player_brain.disable()
	emit_signal("player_active_changed", false)

func enable() -> void:
	player_gun.enable()
	player_brain.enable()
	emit_signal("player_active_changed", true)

func _mouse_moved_x(pixel: float) -> void:
	rotation_degrees.y -= pixel * Globals.mouse_sensitivity
