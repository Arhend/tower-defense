extends BaseTower

const BRUSH_TOWER_V_2_BLUE_4X = preload("uid://b4fd1khnesu7m")
const BRUSH_TOWER_V_2_GREEN_4X = preload("uid://dr83e0t2mcp0m")
const BRUSH_TOWER_V_2_RED_4X = preload("uid://cwr3tpks3e4rs")
const BRUSH_TOWER_V_3_WHITE_4X = preload("uid://cpps5kdp2g1ka")

@onready var animation_player = $AnimationPlayer

func _ready():
    animation_player.play("idle")

func fire_once():
    LoggerManager.debug("Brush Tower fire")
    animation_player.play("fire")
    super.fire_once()
    
func get_tower_texture() -> Texture2D:
    match tower_color:
        TowerColor.RED:
            return BRUSH_TOWER_V_2_RED_4X
        TowerColor.GREEN:
            return BRUSH_TOWER_V_2_GREEN_4X
        TowerColor.BLUE:
            return BRUSH_TOWER_V_2_BLUE_4X
        _:
            return BRUSH_TOWER_V_3_WHITE_4X
            
func _on_attack_timer_timeout():
    animation_player.play("idle")
    super._on_attack_timer_timeout()
