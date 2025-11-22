extends Button

@onready var play_icon = $PlayIcon
@onready var play_label = $PlayLabel

func disable_button():
    disabled = true
    play_icon.modulate = Color(1.0, 1.0, 1.0, 0.471)
    play_label.modulate = Color(1.0, 1.0, 1.0, 0.471)

func enable_button():
    disabled = false
    play_icon.modulate = Color(1.0, 1.0, 1.0, 1)
    play_label.modulate = Color(1.0, 1.0, 1.0, 1)

func _on_pressed():
    if disabled:
        LoggerManager.debug("Wave is active. Button is disabled.")
    else:
        disable_button()
        SignalManager.on_start_next_wave.emit()
