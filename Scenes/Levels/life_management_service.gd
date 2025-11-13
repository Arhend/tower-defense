extends Node2D

@export var lives: int = 100
@onready var life_count = $"../../LevelUI/LifeCount"

func _ready():
    life_count.text = str(lives)
    SignalManager.on_enemy_reached_exit.connect(_on_enemy_reached_exit)
    
func update_lives(value: int):
    lives += value
    life_count.text = str(lives)
    
func _on_enemy_reached_exit():
    update_lives(-1)

    if lives <= 0:
        SignalManager.on_all_lives_lost.emit()
