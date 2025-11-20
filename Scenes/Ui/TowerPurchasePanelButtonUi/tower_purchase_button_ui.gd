extends Button

@onready var tower_texture = $TowerTexture
@onready var tower_name_label = $TowerNameLabel

@export var tower_name: String
@export var texture: Texture2D

func _ready():
    tower_name_label.text = tower_name
    tower_texture.texture = texture
