extends Area2D

class_name BaseEnemy

var in_use := false
var start_position: Vector2 = Vector2.ZERO
var exit_position: Vector2 = Vector2.ZERO

@export var speed: float = 50.0
@export var health: int = 3

@onready var navigation_agent_2d := $NavigationAgent2D

func activate():
    visible = true
    set_physics_process(true)
    in_use = true
    navigation_agent_2d.target_position = exit_position

func deactivate():
    visible = false
    set_physics_process(false)
    in_use = false
    SignalManager.on_enemy_deactivated.emit(self)


func take_damage(damage: int):
    health -= damage
    
    if health <= 0:
       deactivate()
        
func _physics_process(delta):
    if not in_use:
        return

    if navigation_agent_2d.is_navigation_finished():
        deactivate()
        SignalManager.on_enemy_reached_exit.emit()
        return

    var next_position = navigation_agent_2d.get_next_path_position()
    var direction = (next_position - global_position).normalized()
    global_position += direction * speed * delta
