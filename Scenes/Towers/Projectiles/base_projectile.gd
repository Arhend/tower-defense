extends Area2D

class_name BaseProjectile

@export var speed: int = 300
@export var damage: int = 1

# Variable to not accidentally trigger
# multiple enemies to be hit by the projectile if 
# collisions are overlapping
var has_hit := false

func _physics_process(delta):
    position += transform.x * speed * delta

func _on_area_entered(area):
    if area.is_in_group("enemy") and not has_hit:
        has_hit = true
        area.take_damage(damage)
        queue_free()
        
func _on_delete_timer_timeout():
    queue_free()
