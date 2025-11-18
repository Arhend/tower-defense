extends BaseProjectile

@export var max_hits: int = 5

var hit_count: int = 0

func _on_area_entered(area):
    if area.is_in_group("enemy") and hit_count < max_hits:
        hit_count += 1
        area.take_damage(damage)

        if hit_count >= max_hits:
            queue_free()
