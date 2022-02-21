extends Spatial

export(NodePath) var overhead_cam_path: NodePath
export(NodePath) var fps_position_path: NodePath

var overhead_pos: Transform
var fps_pos: Transform

var is_fps: bool = false
var camera: Camera

onready var tween: Tween = $Tween

export(float) var position_transition_time: float = 5.0
export(float) var rotation_transition_time: float = 3.0

var rot_trans_type: int = Tween.TRANS_QUART

var rot_in_ease_type: int = Tween.EASE_IN
var rot_out_ease_type: int = Tween.EASE_OUT

var pos_trans_type: int = Tween.TRANS_SINE

var pos_in_ease_type: int = Tween.EASE_IN
var pos_out_ease_type: int = Tween.EASE_OUT


func _ready() -> void:
	camera = get_node(overhead_cam_path)

	overhead_pos = camera.global_transform
	fps_pos = get_node(fps_position_path).global_transform

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var _t: bool

		if not is_fps:
			_t = tween.interpolate_property(camera, "transform:basis", overhead_pos.basis, fps_pos.basis, rotation_transition_time, rot_trans_type, rot_in_ease_type)
			_t = tween.interpolate_property(camera, "transform:origin", overhead_pos.origin, fps_pos.origin, position_transition_time, pos_trans_type, pos_in_ease_type)
		else:
			_t = tween.interpolate_property(camera, "transform:basis", fps_pos.basis, overhead_pos.basis, rotation_transition_time, rot_trans_type, rot_out_ease_type)
			_t = tween.interpolate_property(camera, "transform:origin", fps_pos.origin, overhead_pos.origin, position_transition_time, pos_trans_type, pos_out_ease_type)

		is_fps = not is_fps
		_t = tween.start()
