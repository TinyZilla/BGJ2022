extends Node

class_name State

func do_state_logic(_delta: float) -> void:
	pass

func check_for_new_state() -> String:
	return self.name

func exit() -> Dictionary:
	return {}

func enter(_init_arg: Dictionary = {}) -> void:
	pass