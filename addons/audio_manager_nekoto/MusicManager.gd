extends Node

onready var music1 = $Music1
onready var music2 = $Music2
onready var tween = $Tween

func _crossfade(stream : AudioStream, duration : float, final_volume : float = 0.0, bus : String = "Master"):
	tween.stop_all()
	
	if music1.playing:
		music2.stream = stream
		music2.bus = bus
		music2.play()
		tween.interpolate_method(self, "ldb_crossfade_m1", db2linear(music1.volume_db), 0.0, duration)
		tween.interpolate_method(self, "ldb_crossfade_m2", 0.0, db2linear(final_volume), duration)
	elif music2.playing:
		music1.stream = stream
		music1.bus = bus
		music1.play()
		tween.interpolate_method(self, "ldb_crossfade_m2", db2linear(music2.volume_db), 0.0, duration)
		tween.interpolate_method(self, "ldb_crossfade_m1", 0.0, db2linear(final_volume), duration)
	else:
		music1.stream = stream
		music1.bus = bus
		music1.play()
		tween.interpolate_method(self, "ldb_crossfade_m2", db2linear(music2.volume_db), 0.0, duration)
		tween.interpolate_method(self, "ldb_crossfade_m1", 0.0, db2linear(final_volume), duration)
	
	tween.start()

func ldb_crossfade_m1(linear_volume : float):
	music1.volume_db = linear2db(linear_volume)

func ldb_crossfade_m2(linear_volume : float):
	music2.volume_db = linear2db(linear_volume)

func _stop_music(duration : float):
	tween.stop_all()
	
	tween.interpolate_method(self, "ldb_crossfade_m1", db2linear(music1.volume_db), 0.0, duration)
	tween.interpolate_method(self, "ldb_crossfade_m2", db2linear(music2.volume_db), 0.0, duration)
	
	tween.start()

func _on_Tween_tween_completed(object, key : String):
	if object == music1 and key == "volume_db" and music1.volume_db <= -80.0:
		music1.stop()
	elif object == music2 and key == "volume_db" and music2.volume_db <= -80.0:
		music2.stop()
