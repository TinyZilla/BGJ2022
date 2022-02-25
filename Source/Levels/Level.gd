extends Spatial

func _ready() -> void:
	StateTransitionManager.on_ready()


	# GameManager.start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_end"):
		GameManager.start()