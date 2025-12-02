extends Area2D

class_name BaseTower

const MAX_LEVEL: int = 5

enum TargetPriorities {
    LAST,
    FIRST
}

enum TowerColor {
    UNPAINTED,
    RED,
    GREEN,
    BLUE,
}

@export var tower_color: TowerColor = TowerColor.UNPAINTED
@export var tower_level: int = 0

@export var tower_stats: TowerStats

@export var projectile: PackedScene
@export var projectile_stats: ProjectileStats

@onready var collision_shape_2d = $AttackRange/CollisionShape2D
@onready var attack_timer = $AttackTimer
@onready var sprite_2d = $Sprite2D

var enemies_in_range: Array[BaseEnemy]
var can_attack := true
var targeting_priority: TargetPriorities = TargetPriorities.FIRST

func _ready():
    collision_shape_2d.shape.radius = tower_stats.attack_range
    SignalManager.on_enemy_deactivated.connect(_on_enemy_deactivated)
    attack_timer.wait_time = tower_stats.attack_speed

    if projectile_stats == null:
        push_error("Projectile Stats not set for tower")
    if tower_stats == null:
        push_error("Tower Stats not set for tower")
            
func try_attack():
    # Only attack if cooldown ready AND we have a target
    if can_attack and enemies_in_range.size() > 0:
        fire_once()
        can_attack = false
        attack_timer.start() # start cooldown

func fire_once():
    var target = enemies_in_range[0]
    if targeting_priority == TargetPriorities.FIRST:
        target = enemies_in_range[0]
    elif targeting_priority == TargetPriorities.LAST:
        target = enemies_in_range[enemies_in_range.size() - 1]
    
    if target and target.in_use:
        spawn_projectile(target)

func spawn_projectile(target: BaseEnemy):
    if projectile:
        var proj = projectile.instantiate()
        proj.name = "Projectile_%s" % UuidManager.v4()
        proj.global_position = global_position
        proj.look_at(target.global_position)

        var scaled_stats = get_scaled_projectile_stats()
        proj.set_projectile_stats(scaled_stats)
        proj.owner_tower = self
        proj.paint_color = tower_color
        get_tree().root.call_deferred("add_child", proj)
        
func get_scaled_projectile_stats() -> ProjectileStats:
    var scaled_stats = projectile_stats.duplicate()
    
    # TODO: Add better damage scaling per level
    scaled_stats.damage = projectile_stats.damage + (tower_level * 5)
    
    return scaled_stats

func register_damage(enemy: BaseEnemy):
    tower_stats.damage_count += 1
    SignalManager.on_tower_damage_dealt.emit(self)

func toggle_priority() -> TargetPriorities:
    targeting_priority = (targeting_priority + 1) % TargetPriorities.size()
    return targeting_priority

func set_tower_color(color: TowerColor):
    if tower_color == TowerColor.UNPAINTED:
        tower_color = color
        LoggerManager.debug("Setting tower paint %s color to: %s" % [name, str(color)])

        # This expects the sprite to have the frames in the order
        # of unpainted to RGB
        match tower_color:
            TowerColor.RED:
                sprite_2d.frame = 1
            TowerColor.GREEN:
                sprite_2d.frame = 2
            TowerColor.BLUE:
                sprite_2d.frame = 3
    else:
        LoggerManager.debug("Tower already painted.")
        
func upgrade_tower_level():
    tower_level += 1

func is_max_level() -> bool:
    return tower_level >= MAX_LEVEL

func get_upgrade_cost() -> int:
    return (tower_stats.cost * 1.5) * (tower_level + 1)

func get_tower_texture() -> Texture2D:
    push_error("Must override in inherited tower")
    return null

func get_tower_color() -> String:
    return TowerColor.keys()[tower_color].capitalize()

func can_upgrade_tower(gold_service: GoldService) -> bool:
    if tower_level <= MAX_LEVEL and gold_service.get_gold_amount() >= get_upgrade_cost():
        return true
    else:
        return false
    
func _on_attack_range_area_entered(area):
    if area.is_in_group("enemy") and area.in_use:
        enemies_in_range.append(area)
        try_attack()

func _on_attack_range_area_exited(area):
    enemies_in_range.erase(area)

func _on_enemy_deactivated(enemy: BaseEnemy):
    enemies_in_range.erase(enemy)

func _on_attack_timer_timeout():
    # Cooldown finished
    can_attack = true

    # If enemy is still here, attack immediately
    try_attack()

func _on_clickable_area_input_event(viewport, event, shape_idx):
    if event.is_action_pressed("primary"):
        if has_meta(TowerPurchaseService.JUST_PLACED):
            remove_meta(TowerPurchaseService.JUST_PLACED)
            return
        SignalManager.on_tower_clicked.emit(self)
