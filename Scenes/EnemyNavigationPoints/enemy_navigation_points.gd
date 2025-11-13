extends Node2D

@onready var spawn_point = $SpawnPoint
@onready var exit_point = $ExitPoint

func get_spawn_position() -> Vector2:
    return spawn_point.global_position + spawn_point.size / 2

func get_exit_position() -> Vector2:
    return exit_point.global_position + exit_point.size / 2
