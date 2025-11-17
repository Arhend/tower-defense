extends Node2D

@export var lives: int = 100
@onready var lives_ui = $"../../LevelUI/LivesUi"

func _ready():
    # Wait to ensure lives ui is ready
    await get_tree().process_frame
    
    lives_ui.set_ui_text(lives)
    SignalManager.on_enemy_reached_exit.connect(_on_enemy_reached_exit)
    
func update_lives(value: int):
    lives += value
    lives_ui.set_ui_text(lives)
    
func _on_enemy_reached_exit(enemy: BaseEnemy):
    update_lives(-1 * enemy.health)

    if lives <= 0:
        SignalManager.on_all_lives_lost.emit()
