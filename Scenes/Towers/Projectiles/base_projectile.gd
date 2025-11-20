extends Area2D

class_name BaseProjectile

@export var speed: int = 300

var projectile_pierce_limit: int = 5
var hit_count: int = 0
var damage: int = 1
var owner_tower: BaseTower = null

# Variable to not accidentally trigger
# multiple enemies to be hit by the projectile if
# collisions are overlapping
var has_hit := false

func _physics_process(delta):
    position += transform.x * speed * delta
    
func set_projectile_stats(projectile_stats: ProjectileStats):
    damage = projectile_stats.damage
    projectile_pierce_limit = projectile_stats.pierce_limit

func _on_area_entered(area):
    if area.is_in_group("enemy") and hit_count < projectile_pierce_limit:
        hit_count += 1
        var enemy_health_before = area.health
        area.take_damage(damage)
        owner_tower.register_damage(area)

        if hit_count >= projectile_pierce_limit:
            queue_free()
        
func _on_delete_timer_timeout():
    queue_free()
