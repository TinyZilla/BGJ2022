extends Node

onready var music_manager = $MusicManager

const generic_player = preload("res://addons/audio_manager_nekoto/GenericPlayer.tscn")

var ambience_dict := {}

func crossfade_music(stream : AudioStream, duration : float, final_volume : float = 0.0, bus : String = "Master"):
	music_manager._crossfade(stream, duration, final_volume, bus)

func stop_music(duration : float):
	music_manager._stop_music(duration)

func play_sfx(stream : AudioStream, bus : String = "Master", volume_db : float = 0.0):
	var gp = generic_player.instance()
	add_child(gp)
	gp.sfx(stream)
	gp.volume_db = volume_db
	gp.bus = bus

func play_ambience(stream : AudioStream, fade_in_duration : float, ambience_name : String, bus : String = "Ambience"):
	var gp = generic_player.instance()
	add_child(gp)
	ambience_dict[ambience_name] = gp
	gp.bus = bus
	gp.fade_in(stream, fade_in_duration)

func crossfade_ambience(stream : AudioStream, duration : float, ambience_name : String, bus : String = "Ambience"):
	if ambience_name in ambience_dict.keys():
		var gp = ambience_dict[ambience_name]
		gp.fade_out(duration)
		ambience_dict.erase(gp)
		play_ambience(stream, duration, ambience_name, bus)

func stop_ambience(ambience_name : String, duration : float):
	if ambience_name in ambience_dict.keys():
		var gp = ambience_dict[ambience_name]
		gp.fade_out(duration)
