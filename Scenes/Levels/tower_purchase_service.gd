extends Node2D

const BRUSH_TOWER = preload("uid://jtug3iwvv4pg")
const BRUSH_TOWER_TEXTURE = preload("uid://csfaw2blqjs8v")

var selected_tower: PackedScene = null
var can_place := true

@onready var selected_tower_area = $SelectedTowerArea
@onready var selected_texture = $SelectedTowerArea/SelectedTexture

func _input(event):
    if selected_tower and event.is_action_pressed("primary"):
        if can_place:
            activate(event.position)
    elif selected_tower and event.is_action_pressed("secondary"):
        deactivate()

func _process(delta):
    if selected_tower:
        selected_tower_area.global_position = get_global_mouse_position()

func activate(screen_position: Vector2):
    LoggerManager.debug("Placing %s" % selected_tower)

    var tower_instance = selected_tower.instantiate()
    tower_instance.global_position = get_viewport().get_canvas_transform().affine_inverse() * screen_position
    add_child(tower_instance)

    deactivate()

func deactivate():
    selected_tower = null
    selected_texture.visible = false

func _on_brush_tower_button_pressed():
    selected_tower = BRUSH_TOWER
    selected_texture.texture = BRUSH_TOWER_TEXTURE
    selected_texture.visible = true

func enable_placement():
    LoggerManager.debug("Able to place.")
    can_place = true
    selected_texture.modulate = Color.WHITE
    
func disable_placement():
    LoggerManager.debug("Unable to place.")
    can_place = false
    selected_texture.modulate = Color.RED

func _on_selected_tower_area_area_entered(area):
    disable_placement()
    
func _on_selected_tower_area_area_exited(area):
    enable_placement()
    
# This is for no build layer since the tilemap
# has physical bodies rather area2d
func _on_selected_tower_area_body_entered(body):
    disable_placement()
    
func _on_selected_tower_area_body_exited(body):
    enable_placement()
