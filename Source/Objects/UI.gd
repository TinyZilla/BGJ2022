extends CanvasLayer

signal resume_pressed

func _enter_tree() -> void:
	Globals.user_interface = self

func _ready() -> void:
	$MainMenu.set_visible(true)

func player_active_changed(is_enable: bool) -> void:
	$HUD.set_visible(is_enable)

func show_retry_menu() -> void:
	$RetryMenu.set_visible(true)

func _on_StartGame_pressed() -> void:
	$MainMenu.set_visible(false)
	GameManager.start()

func show_end_screen() -> void:
	$EndScreen.set_visible(true)

func _on_RetryButton_pressed() -> void:
	$RetryMenu.set_visible(false)
	emit_signal("resume_pressed")
