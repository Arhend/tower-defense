extends Button

@onready var tower_texture = $TowerTexture
@onready var tower_name_label = $TowerNameLabel
@onready var tower_cost_label = $TowerCostLabel

@export var tower_stats: TowerStats
@export var tower_name: String
@export var texture: Texture2D

func _ready():
    tower_name_label.text = tower_name
    tower_texture.texture = texture
    tower_cost_label.text = str(tower_stats.cost)
    
    SignalManager.on_gold_updated.connect(_on_gold_updated)
    
func _on_gold_updated(total_gold: int):
    if total_gold < tower_stats.cost:
        disabled = true
        tower_texture.modulate = Color(1, 1, 1, .5)
    else:
        disabled = false
        tower_texture.modulate = Color(1, 1, 1, 1)
