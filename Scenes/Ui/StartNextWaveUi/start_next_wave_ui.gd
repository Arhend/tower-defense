extends ColorRect

@onready var start_next_wave_button = $StartNextWaveButton

var is_disabled := false

func disable_button():
    is_disabled = true
    modulate = Color.BLACK
    
func enable_button():
    is_disabled = false
    modulate = Color.WHITE

func _on_start_next_wave_button_pressed():
    if is_disabled:
        LoggerManager.debug("Wave is active. Button is disabled.")
    else:
        disable_button()
        SignalManager.on_start_next_wave.emit()
