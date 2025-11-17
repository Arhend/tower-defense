extends Node2D

@export var gold_ui: GoldUI
@export var gold := 0

func _ready():
    SignalManager.on_gold_earned.connect(_on_gold_earned)
    SignalManager.on_gold_removed.connect(_on_gold_removed)

    # Wait to ensure gold ui is ready
    await get_tree().process_frame
    
    if not gold_ui:
        push_error("Missing Gold UI Element")
        return
        
    gold_ui.set_ui_text(gold)

func _on_gold_earned(value: int):
    gold += value
    gold_ui.set_ui_text(gold)

func _on_gold_removed(value: int):
    gold -= value
    gold_ui.set_ui_text(gold)
