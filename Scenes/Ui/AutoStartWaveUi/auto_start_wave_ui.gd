extends Panel

@onready var auto_start_toggle_button = $HBoxContainer/AutoStartToggleButton

func _ready():
    auto_start_toggle_button.button_pressed = SettingsManager.autostart_waves

func _on_check_button_toggled(toggled_on):
    SettingsManager.set_autostart_waves(toggled_on)
    SignalManager.on_toggle_autostart_waves.emit(toggled_on)
