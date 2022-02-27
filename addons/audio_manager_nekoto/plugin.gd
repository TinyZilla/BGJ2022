tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("AudioManager", "res://addons/audio_manager_nekoto/AudioManager.tscn")

func _exit_tree():
	remove_autoload_singleton("AudioManager")
