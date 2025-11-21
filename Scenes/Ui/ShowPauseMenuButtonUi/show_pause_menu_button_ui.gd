extends ColorRect

@export var pause_menu: PauseMenuUi

func _on_settings_button_pressed():
    LoggerManager.debug("Settings Button Pressed")
    pause_menu.show_pause_menu()
