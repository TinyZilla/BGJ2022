extends AudioStreamPlayer3D

const sfx := [
	preload("res://Audio/SFX/Enemy_Sword1.wav"),
	preload("res://Audio/SFX/Enemy_Sword2.wav"),
	preload("res://Audio/SFX/Enemy_Sword3.wav"),
	preload("res://Audio/SFX/Enemy_Sword4.wav"),
]

func slash():
	stream = sfx[randi()%sfx.size()]
	play()
