extends Node2D

@export var show_no_build_tiles: bool = false

@onready var enemy_pooling_service = $Services/EnemyPoolingService
@onready var tower_no_build = $Tilemaps/TowerNoBuild


func _ready():
    if show_no_build_tiles:
        tower_no_build.z_index = 1000
    else:
        tower_no_build.z_index = 0
