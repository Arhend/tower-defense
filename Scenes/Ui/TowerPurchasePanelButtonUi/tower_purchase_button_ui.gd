extends Button

@onready var tower_texture = $TowerTexture
@onready var tower_name_label = $TowerNameLabel

@export var tower_stats: TowerStats
@export var tower_name: String
@export var texture: Texture2D

func _ready():
    tower_name_label.text = tower_name
    tower_texture.texture = texture

    SignalManager.on_gold_updated.connect(_on_gold_updated)
    
func _on_gold_updated(total_gold: int):
    if total_gold < tower_stats.cost:
        disabled = true
    else:
        disabled = false
