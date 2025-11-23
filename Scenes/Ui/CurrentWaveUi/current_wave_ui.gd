extends ColorRect

@onready var current_wave_label = $HBoxContainer/CurrentWaveLabel

func set_ui_text(value: int):
    current_wave_label.text = str(value)
