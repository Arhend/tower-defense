extends Area2D

class_name BaseTower

@export var attack_range: float = 100.0
@export var attack_speed: float = 3.0
@export var projectile: PackedScene

@onready var collision_shape_2d = $AttackRange/CollisionShape2D
@onready var attack_timer = $AttackTimer

var enemies_in_range: Array[BaseEnemy]

func _ready():
    collision_shape_2d.shape.radius = attack_range
    SignalManager.on_enemy_deactivated.connect(_on_enemy_deactivated)
    attack_timer.wait_time = attack_speed

func attack():
    if attack_timer.is_stopped() and len(enemies_in_range) > 0:
        attack_timer.start(attack_timer.wait_time)
        LoggerManager.debug("Attacking %s" % enemies_in_range[0].name)
        attack_timer.start()

        spawn_projectile(enemies_in_range[0])
    else:
        attack_timer.stop()

func spawn_projectile(target: BaseEnemy):
    if projectile:
        var proj = projectile.instantiate()
        proj.name = "Projectile_%s" % UuidManager.v4()
        proj.global_position = global_position
        proj.look_at(target.global_position)
        get_tree().root.call_deferred("add_child", proj)
        
func _on_attack_range_area_entered(area):
    if area.is_in_group("enemy") and area.in_use:
        enemies_in_range.append(area)
        attack()

func _on_attack_range_area_exited(area):
    if area.is_in_group("enemy") and area.in_use:
        enemies_in_range.erase(area)

func _on_enemy_deactivated(enemy: BaseEnemy):
    enemies_in_range.erase(enemy)

func _on_attack_timer_timeout():
    attack()
