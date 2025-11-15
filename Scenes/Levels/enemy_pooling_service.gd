extends Node2D

class_name EnemyPoolingService

enum EnemyTypes {
    DRIPLET,
    SMEARLING,
    GLOPLET
}

const DRIPLET = preload("uid://bgvhrko6ftggv")
const SMEARLING = preload("uid://comxgg8k75orh")
const GLOPLET = preload("uid://dtw3a3qlxarfw")


var driplet_pool: Array[Driplet] = []
var smearling_pool: Array[Smearling] = []
var gloplet_pool: Array[Gloplet] = []

@export var initial_size: int = 10

@onready var enemy_navigation_points = $EnemyNavigationPoints

func _ready():
    _create_pool(DRIPLET, "DRIPLET", initial_size, driplet_pool)
    _create_pool(SMEARLING, "SMEARLING", initial_size, smearling_pool)
    _create_pool(GLOPLET, "GLOPLET", initial_size, gloplet_pool)

func _create_pool(enemy_scene: PackedScene, enemy_type_name: String, count: int, pool: Array) -> void:
    for i in count:
        var enemy = enemy_scene.instantiate()
        enemy.name = "%s%s" % [enemy_type_name, UuidManager.v4()]
        enemy.visible = false
        enemy.set_physics_process(false)
        pool.append(enemy)
        add_child(enemy)

func spawn_enemy(enemy_type: EnemyTypes) -> BaseEnemy:
    var pool: Array
    match enemy_type:
        EnemyTypes.DRIPLET:
            pool = driplet_pool
        EnemyTypes.SMEARLING:
            pool = smearling_pool
        EnemyTypes.GLOPLET:
            pool = gloplet_pool

    for enemy in pool:
        if not enemy.in_use:
            enemy.global_position = enemy_navigation_points.get_spawn_position()

            enemy.start_position = enemy_navigation_points.get_spawn_position()
            enemy.exit_position = enemy_navigation_points.get_exit_position()
            enemy.activate()
            return enemy

    # No available enemy, so create a new one
    return _create_new_enemy(enemy_type)

func _create_new_enemy(enemy_type: EnemyTypes) -> BaseEnemy:
    var new_enemy: BaseEnemy
    var enemy_name: String
    var pool: Array

    match enemy_type:
        EnemyTypes.DRIPLET:
            new_enemy = DRIPLET.instantiate()
            enemy_name = "DRIPLET_%s" % UuidManager.v4()
            pool = driplet_pool
        EnemyTypes.SMEARLING:
            new_enemy = SMEARLING.instantiate()
            enemy_name = "SMEARLING_%s" % UuidManager.v4()
            pool = smearling_pool
        EnemyTypes.GLOPLET:
            new_enemy = GLOPLET.instantiate()
            enemy_name = "GLOPLET_%s" % UuidManager.v4()
            pool = gloplet_pool

    new_enemy.name = enemy_name
    pool.append(new_enemy)
    add_child(new_enemy)
    new_enemy.activate()
    return new_enemy
