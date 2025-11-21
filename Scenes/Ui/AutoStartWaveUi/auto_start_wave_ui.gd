extends ColorRect

@onready var debug_label = $HBoxContainer/DebugLabel

func _on_auto_start_wave_button_pressed():
    SignalManager.on_toggle_autostart_waves.emit()
    
    if debug_label.text == "OFF":
        debug_label.text = "ON"
    else:
        debug_label.text = "OFF"
