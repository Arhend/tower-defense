extends Area2D

class_name BaseProjectile

var speed: int = 300
var damage: int = 1

func _physics_process(delta):
    position += transform.x * speed * delta

func _on_area_entered(area):
    if area.is_in_group("enemy"):
        area.take_damage(damage)
        queue_free()
        
func _on_delete_timer_timeout():
    queue_free()
