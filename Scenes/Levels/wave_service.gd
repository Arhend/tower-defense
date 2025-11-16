extends Node2D

@export var waves = [
    { "type": EnemyPoolingService.EnemyTypes.DRIPLET,  "count": 5,  "delay": 0.6 },
    { "type": EnemyPoolingService.EnemyTypes.DRIPLET,  "count": 15, "delay": 0.4 },
    { "type": EnemyPoolingService.EnemyTypes.SMEARLING, "count": 8,  "delay": 0.5 },
]
@export var time_between_waves: float = 5.0

@onready var enemy_pooling_service: EnemyPoolingService = $"../EnemyPoolingService"
@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer

var current_wave := 0
var to_spawn := 0
var enemy_type := 0
var spawn_delay := 0.5

func _ready():
    start_wave()

func start_wave():
    if current_wave >= waves.size():
        print("All waves complete!")
        return

    LoggerManager.debug("Starting wave...")
    var wave = waves[current_wave]
    enemy_type = wave["type"]
    to_spawn = wave.get("count", 1)
    spawn_delay = wave.get("delay", 0.5)

    spawn_timer.wait_time = spawn_delay
    spawn_timer.start()

func _on_wave_timer_timeout():
    wave_timer.stop()
    current_wave += 1
    start_wave()

func _on_spawn_timer_timeout():
    if to_spawn <= 0:
        # Wave finished → start cooldown before next wave
        spawn_timer.stop()
        wave_timer.wait_time = time_between_waves
        wave_timer.start()
        return

    # Spawn enemy from your pool
    enemy_pooling_service.spawn_enemy(enemy_type)
    to_spawn -= 1
