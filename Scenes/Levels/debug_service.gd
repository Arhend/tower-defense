extends Node2D

const EnemyTypes = EnemyPoolingService.EnemyTypes

@onready var enemy_pooling_service = $"../EnemyPoolingService"

var activate_enemy_count := 0

func _on_activate_enemy_timer_timeout():
    if activate_enemy_count % 4 == 0:
        enemy_pooling_service.spawn_enemy(EnemyTypes.SMEARLING)
    else:
        enemy_pooling_service.spawn_enemy(EnemyTypes.DRIPLET)

    activate_enemy_count += 1
