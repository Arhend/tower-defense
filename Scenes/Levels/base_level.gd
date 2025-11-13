extends Node2D

@onready var enemy_pooling_service = $Services/EnemyPoolingService

func _ready():
    enemy_pooling_service.spawn_enemy()
