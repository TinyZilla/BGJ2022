extends AudioStreamPlayer

onready var ap = $AnimationPlayer

func fade_in(audio_stream : AudioStream, duration : float = 1.0):
	stream = audio_stream
	play()
	ap.play("fade_in", -1, 1.0 / duration)

func fade_out(duration : float = 1.0):
	ap.play("fade_out", -1, 1.0 / duration)

func sfx(audio_stream : AudioStream):
	stream = audio_stream
	connect("finished", self, "kill")
	play()

func kill():
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		kill()
