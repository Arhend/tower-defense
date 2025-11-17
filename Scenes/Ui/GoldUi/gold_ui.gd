extends Control

class_name GoldUI

@onready var gold_label = $HBoxContainer/GoldLabel

func set_ui_text(value: int):
    gold_label.text = str(value)
