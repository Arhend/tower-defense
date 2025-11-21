extends Button

func _on_pressed():
    LoggerManager.debug("Toggling Fastforward State")
    SignalManager.on_toggle_fast_forward.emit()

func update_button_text(value: String):
    text = value    
