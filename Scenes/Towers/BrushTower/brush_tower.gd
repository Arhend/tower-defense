extends BaseTower

@onready var animation_player = $AnimationPlayer

func _ready():
    animation_player.play("idle")

func fire_once():
    LoggerManager.debug("Brush Tower fire")
    animation_player.play("fire")
    super.fire_once()


func _on_attack_timer_timeout():
    animation_player.play("idle")
    super._on_attack_timer_timeout()
