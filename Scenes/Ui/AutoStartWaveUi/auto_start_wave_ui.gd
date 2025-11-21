extends Panel

@onready var auto_start_toggle_button = $HBoxContainer/AutoStartToggleButton

func _ready():
    pass

func _on_check_button_toggled(toggled_on):
    SignalManager.on_toggle_autostart_waves.emit()
