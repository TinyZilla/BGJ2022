extends AudioStreamPlayer3D

var i : int = 0

const sfx := [
	preload("res://Audio/SFX/Enemy_Footstep1.wav"),
	preload("res://Audio/SFX/Enemy_Footstep2.wav"),
]

func footstep():
	if i > sfx.size() - 1:
		i = 0
	
	stream = sfx[i]
	play()
	i += 1

