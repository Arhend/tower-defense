extends BaseTower

@onready var animation_player = $AnimationPlayer

func _ready():
    animation_player.play("idle")
