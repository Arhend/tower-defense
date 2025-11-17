extends Control

class_name LivesUi

@onready var lives_label = $HBoxContainer/LivesLabel

func set_ui_text(value: int):
    lives_label.text = str(value)
