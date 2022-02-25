extends CanvasLayer

func _ready() -> void:
	$MainMenu.set_visible(true)

func player_active_changed(is_enable: bool) -> void:
	$HUD.set_visible(is_enable)

func _on_StartGame_pressed() -> void:
	$MainMenu.set_visible(false)
	GameManager.start()
