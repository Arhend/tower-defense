extends Node2D

@onready var enemy_pooling_service = $"../EnemyPoolingService"

func _on_activate_enemy_timer_timeout():
    enemy_pooling_service.spawn_enemy()
