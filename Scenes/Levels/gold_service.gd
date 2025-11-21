extends Node2D

class_name GoldService

@onready var gold_ui = $"../../LevelUI/VBoxContainerUi/TopRowUi/PanelContainer/DataHBox/GoldUI"

@export var gold := 0

func _ready():
    SignalManager.on_gold_earned.connect(_on_gold_earned)
    SignalManager.on_gold_removed.connect(_on_gold_removed)

    # Wait to ensure gold ui is ready
    await get_tree().process_frame
    
    gold_ui.set_ui_text(gold)

func get_gold_amount() -> int:
    return gold

func _on_gold_earned(value: int):
    gold += value
    gold_ui.set_ui_text(gold)
    SignalManager.on_gold_updated.emit(gold)

func _on_gold_removed(value: int):
    gold -= value
    gold_ui.set_ui_text(gold)
    SignalManager.on_gold_updated.emit(gold)
