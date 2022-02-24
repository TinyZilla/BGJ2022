extends Node

signal skyfall_finished

var cluster_start_location: Vector3
onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

onready var tween: Tween = $Tween

func _ready() -> void:
	rng.randomize()
	var _t = tween.connect("tween_all_completed", self, "tween_finished")

func drop_group(group_str: String) -> void:
	var _t

	for bond in get_tree().get_nodes_in_group(group_str):
		_t = tween.interpolate_property(bond, "global_transform:origin", cluster_start_location, bond.fall_location, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT, rng.randf_range(0,0.5))
	
		_t = tween.start()

func tween_finished() -> void:
	emit_signal("skyfall_finished")
	print("done")