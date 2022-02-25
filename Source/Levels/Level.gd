extends Spatial

func _ready() -> void:
	StateTransitionManager.on_ready()


	GameManager.start()
