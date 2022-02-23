extends Spatial

onready var ap = $AnimationPlayer

func _process(_delta):
	if Input.is_action_just_pressed("LMB"):
		ap.play("fire", -1, Globals.gun_fire_rate)

