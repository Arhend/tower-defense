extends TextureButton

@export var pause_menu: PauseMenuUi

func reset_modulate():
    modulate = Color.WHITE

func _on_pressed():
    LoggerManager.debug("Settings Button Pressed")
    pause_menu.show_pause_menu()

func _on_button_down():
    modulate = Color(1, 1, 1, .5)

func _on_button_up():
    reset_modulate()

func _on_mouse_entered():
    modulate = Color(1, 1, 1, .75)

func _on_mouse_exited():
    reset_modulate()
