extends Area2D

class_name BaseProjectile

const TowerColor = preload("res://Scenes/Towers/base_tower.gd").TowerColor

const BLUE_PAINT_BLOB = preload("uid://bb0ebqemw7okq")
const GREEN_PAINT_BLOB = preload("uid://dcxmofnpej111")
const RED_PAINT_BLOB = preload("uid://5m5lt3kdvyxw")

@export var speed: int = 300

var projectile_pierce_limit: int = 5
var hit_count: int = 0
var damage: int = 1
var owner_tower: BaseTower = null
var paint_color: TowerColor = TowerColor.UNPAINTED

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

func spawn_paint_blob():
    var paint_blob_scene = null
    var color_name = ""

    match paint_color:
        TowerColor.RED:
            paint_blob_scene = RED_PAINT_BLOB
            color_name = "RED"
        TowerColor.BLUE:
            paint_blob_scene = BLUE_PAINT_BLOB
            color_name = "BLUE"
        TowerColor.GREEN:
            paint_blob_scene = GREEN_PAINT_BLOB
            color_name = "GREEN"

    if paint_blob_scene:
        var paint_blob = paint_blob_scene.instantiate()
        paint_blob.name = "%s_PAINT_BLOB_%s" % [color_name, UuidManager.v4()]
        paint_blob.global_position = global_position
        get_tree().root.add_child(paint_blob)

func _on_spawn_paint_blob_timer_timeout():
    spawn_paint_blob()
