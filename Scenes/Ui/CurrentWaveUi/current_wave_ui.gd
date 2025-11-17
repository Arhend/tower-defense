extends ColorRect

@onready var current_wave_label = $CurrentWaveLabel

func set_ui_text(value: int):
    current_wave_label.text = str(value)
