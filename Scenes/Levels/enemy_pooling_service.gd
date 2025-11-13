extends Node2D

class_name EnemyPoolingService

const DRIPLET = preload("uid://bgvhrko6ftggv")

var pool: Array[BaseEnemy] = []

@export var initial_size: int = 10

@onready var enemy_navigation_points = $EnemyNavigationPoints

func _ready():
    for i in initial_size:
        var enemy = DRIPLET.instantiate()
        enemy.name = "DRIPLET%s" % UuidManager.v4()
        enemy.visible = false
        enemy.set_physics_process(false)
        pool.append(enemy)
        add_child(enemy)

func spawn_enemy() -> BaseEnemy:
    for enemy in pool:
        if not enemy.in_use:
            enemy.global_position = enemy_navigation_points.get_spawn_position()

            enemy.start_position = enemy_navigation_points.get_spawn_position()
            enemy.exit_position = enemy_navigation_points.get_exit_position()
            enemy.activate()
            return enemy
            
    # No available enemy, so create a new one
    return _create_new_enemy()

func _create_new_enemy() -> BaseEnemy:
    var new_enemy = DRIPLET.instantiate()
    new_enemy.name = "DRIPLET_%s" % UuidManager.v4()
    pool.append(new_enemy)
    add_child(new_enemy)
    new_enemy.activate()
    return new_enemy
