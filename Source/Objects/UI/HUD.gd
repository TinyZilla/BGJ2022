extends Control

func _ready():
	StateTransitionManager.connect("transition_finished", self, "transition_finished")

func transition_finished(is_fps : bool):
	visible = is_fps

