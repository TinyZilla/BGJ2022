extends AudioStreamPlayer3D

const sfx := [
	preload("res://Audio/SFX/Enemy_Pain1.wav"),
	preload("res://Audio/SFX/Enemy_Pain2.wav"),
	preload("res://Audio/SFX/Enemy_Pain3.wav"),
]

func _ready():
	stream = sfx[randi()%sfx.size()]
	play()

func _on_EnemyHurtSFX_finished():
	queue_free()
