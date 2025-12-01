extends BaseTower

const BRUSH_TOWER_V_4_6X = preload("uid://d0xr3n6r31hkh")

@onready var animation_player = $AnimationPlayer

func _ready():
    animation_player.play("idle")

func fire_once():
    LoggerManager.debug("Brush Tower fire")
    animation_player.play("fire")
    super.fire_once()
    
func get_tower_texture() -> Texture2D:
    return BRUSH_TOWER_V_4_6X

func _on_attack_timer_timeout():
    animation_player.play("idle")
    super._on_attack_timer_timeout()
