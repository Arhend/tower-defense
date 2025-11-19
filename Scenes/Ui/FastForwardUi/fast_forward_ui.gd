extends ColorRect

@onready var debug_speed_label = $HBoxContainer/DebugSpeedLabel

func update_debug_label(value: String):
    debug_speed_label.text = value

func _on_fast_forward_button_pressed():
    LoggerManager.debug("Toggling Fastforward State")
    SignalManager.on_toggle_fast_forward.emit()
