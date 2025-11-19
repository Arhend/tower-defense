extends Node2D

@export var wave_data: Array[WaveData] = []

@onready var enemy_pooling_service: EnemyPoolingService = $"../EnemyPoolingService"
@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer
@onready var current_wave_ui = $"../../LevelUI/VBoxContainerUi/TopRowUi/DataHBox/CurrentWaveUi"
@onready var start_next_wave_ui = $"../../LevelUI/VBoxContainerUi/TopRowUi/ControlHBox/StartNextWaveUi"

var current_wave := 0
var spawn_queue: Array[EnemySpawnData] = []
var spawn_index := 0
var active_enemies := 0
var auto_start_waves := false

func _ready():
    SignalManager.on_enemy_deactivated.connect(_on_enemy_deactivated)
    SignalManager.on_start_next_wave.connect(_on_start_next_wave)
    SignalManager.on_toggle_autostart_waves.connect(_on_toggle_autostart_waves)
    
func start_wave():
    LoggerManager.debug("Starting wave %d" % current_wave)
    
    var current_wave_data = wave_data[current_wave]
    spawn_queue = current_wave_data.enemy_spawn_data.duplicate()
    spawn_index = 0

    if spawn_queue.size() > 0:
        spawn_timer.start(spawn_queue[0].spawn_delay)

func spawn_next_enemy():
    if spawn_index < spawn_queue.size():
        var spawn_data = spawn_queue[spawn_index]
        enemy_pooling_service.spawn_enemy(spawn_data.enemy_type)
        active_enemies += 1
        spawn_index += 1

        if spawn_index < spawn_queue.size():
            spawn_timer.start(spawn_queue[spawn_index].spawn_delay)


func wave_finished():
    LoggerManager.debug("Wave finished")
    spawn_index = 0
    current_wave += 1

    # Adding 1 since waves are 0 indexed
    current_wave_ui.set_ui_text(current_wave + 1)

    # Wave is done let us go to next on user input
    start_next_wave_ui.enable_button()

    if auto_start_waves:
        start_wave()

func _on_enemy_deactivated(_enemy: BaseEnemy):
    active_enemies -= 1

    if active_enemies <= 0 and spawn_index >= spawn_queue.size():
        wave_finished()

func _on_wave_timer_timeout():
    pass

func _on_spawn_timer_timeout():
    spawn_next_enemy()
        
func _on_start_next_wave():
    # Do we have anymore waves left?
    if current_wave >= wave_data.size():
        LoggerManager.debug("No more waves to spawn")
        return
        
    start_wave()

func _on_toggle_autostart_waves():
    auto_start_waves = !auto_start_waves
