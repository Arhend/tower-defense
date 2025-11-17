extends Node2D

const BRUSH_TOWER = preload("uid://jtug3iwvv4pg")
const BRUSH_TOWER_TEXTURE = preload("uid://csfaw2blqjs8v")

var selected_tower: PackedScene = null
var can_place := true

@onready var selected_tower_area = $SelectedTowerArea
@onready var selected_texture = $SelectedTowerArea/SelectedTexture
@onready var gold_service = $"../GoldService"

# Built-in virtual methods
func _input(event):
    if selected_tower and event.is_action_pressed("primary"):
        if can_place:
            activate(event.position)
    elif selected_tower and event.is_action_pressed("secondary"):
        deactivate()

func _process(_delta):
    if selected_tower:
        selected_tower_area.global_position = get_global_mouse_position()

# Public methods
func activate(screen_position: Vector2):
    LoggerManager.debug("Placing %s" % selected_tower)
    var tower_instance = selected_tower.instantiate()
    tower_instance.global_position = get_viewport().get_canvas_transform().affine_inverse() * screen_position
    add_child(tower_instance)
    SignalManager.on_gold_removed.emit(tower_instance.cost)
    deactivate()

func deactivate():
    selected_tower = null
    selected_texture.visible = false

func has_enough_gold(tower_scene: PackedScene) -> bool:
    var temp_tower = tower_scene.instantiate()
    var tower_cost = temp_tower.cost
    temp_tower.queue_free()
    return gold_service.get_gold_amount() >= tower_cost

# Helper methods
func enable_placement():
    LoggerManager.debug("Able to place.")
    can_place = true
    selected_texture.modulate = Color.WHITE

func disable_placement():
    LoggerManager.debug("Unable to place.")
    can_place = false
    selected_texture.modulate = Color.RED

# Signal callbacks
func _on_brush_tower_button_pressed():
    if has_enough_gold(BRUSH_TOWER):
        selected_tower = BRUSH_TOWER
        selected_texture.texture = BRUSH_TOWER_TEXTURE
        selected_texture.visible = true
    else:
        LoggerManager.debug("Not enough gold for tower.")

func _on_selected_tower_area_area_entered(_area):
    disable_placement()

func _on_selected_tower_area_area_exited(_area):
    enable_placement()

func _on_selected_tower_area_body_entered(_body):
    disable_placement()

func _on_selected_tower_area_body_exited(_body):
    enable_placement()
