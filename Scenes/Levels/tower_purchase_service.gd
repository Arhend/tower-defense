extends Node2D

const BRUSH_TOWER = preload("uid://jtug3iwvv4pg")
const BRUSH_TOWER_TEXTURE = preload("uid://csfaw2blqjs8v")

var selected_tower: PackedScene = null

@onready var selected_texture = $SelectedTexture

func _input(event):
    if selected_tower and event.is_action_pressed("primary"):
        activate(event.position)
    elif selected_tower and event.is_action_pressed("secondary"):
        deactivate()

func _process(delta):
    if selected_tower:
        selected_texture.global_position = get_global_mouse_position()

func activate(screen_position: Vector2):
    LoggerManager.debug("Placing %s" % selected_tower)

    # TODO: Need to add logic to determine if valid placement
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
