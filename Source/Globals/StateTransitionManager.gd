extends Node

# Transition between First person and Top down view.
# From FPS -> Top Down
# Move the Overview Cam to Player Cam Location / Rotation
# Disable FPS cam, enable overview cam
# Play the transition
# On transition End, Signal.
# Vice Versa

signal transition_finished(is_fps)

# Player
var player: Node

# Reference to the FPS Camera
var player_cam: Camera
# Reference to the Overhead Camera
var overhead_cam: Camera

var overhead_cam_global_transform: Transform

var is_fps: bool = false
onready var tween: Tween = $Tween

export(float) var position_transition_time: float = 0.75
export(float) var rotation_transition_time: float = 0.75

var rot_trans_type: int = Tween.TRANS_QUART

var rot_in_ease_type: int = Tween.EASE_IN
var rot_out_ease_type: int = Tween.EASE_OUT

var pos_trans_type: int = Tween.TRANS_SINE

var pos_in_ease_type: int = Tween.EASE_IN
var pos_out_ease_type: int = Tween.EASE_OUT

const bgm := {
	"your_reality" : preload("res://Audio/BGM/BGJ_RealityMix.wav"),
	"combat" : preload("res://Audio/BGM/BGJ_CombatMix.wav")
}
var bgm_volume : float = -25.0

func on_ready() -> void:
	if overhead_cam == null or player_cam == null:
		print("State Transition Manager Not set up correctly. Not doing anyhting")
		return

	overhead_cam_global_transform = overhead_cam.global_transform

	player_cam.current = false
	overhead_cam.current = true

	player.disable()

	var _t = tween.connect("tween_all_completed", self, "tween_finished")
	
	AudioManager.crossfade_music(bgm["your_reality"], 1.0, bgm_volume, "BGM")

func transition() -> void:
	if overhead_cam == null or player_cam == null:
		print("State Transition Manager Not set up correctly. Not doing anyhting")
		return
	
	var player_cam_global_transform = player_cam.global_transform

	var _t: bool

	if not is_fps:
		_t = tween.interpolate_property(overhead_cam, "transform:basis", overhead_cam_global_transform.basis, player_cam_global_transform.basis, rotation_transition_time, rot_trans_type, rot_in_ease_type)
		_t = tween.interpolate_property(overhead_cam, "transform:origin", overhead_cam_global_transform.origin, player_cam_global_transform.origin, position_transition_time, pos_trans_type, pos_in_ease_type)
		player.disable()
		AudioManager.crossfade_music(bgm["combat"], 1.0, bgm_volume, "BGM")
	else:
		_t = tween.interpolate_property(overhead_cam, "transform:basis", player_cam_global_transform.basis, overhead_cam_global_transform.basis, rotation_transition_time, rot_trans_type, rot_out_ease_type)
		_t = tween.interpolate_property(overhead_cam, "transform:origin", player_cam_global_transform.origin, overhead_cam_global_transform.origin, position_transition_time, pos_trans_type, pos_out_ease_type)
		
		AudioManager.crossfade_music(bgm["your_reality"], 1.0, bgm_volume, "BGM")
		
		player.disable()
		player_cam.current = false
		overhead_cam.current = true

	is_fps = not is_fps
	_t = tween.start()

func tween_finished() -> void:
	if is_fps:
		overhead_cam.current = false
		player_cam.current = true
		player.enable()
	emit_signal("transition_finished", is_fps)
