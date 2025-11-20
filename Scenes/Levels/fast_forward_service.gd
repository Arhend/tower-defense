extends Node2D

enum FastForwardSpeed {
    SPEED_1X,
    SPEED_2X,
    SPEED_3X,
    SPEED_4X
}

var fast_forward_state: FastForwardSpeed = FastForwardSpeed.SPEED_1X

@onready var fast_forward_ui = $"../../LevelUI/VBoxContainerUi/TopRowUi/PanelContainer2/ControlHBox/FastForwardUi"

func _ready():
    SignalManager.on_toggle_fast_forward.connect(_on_toggle_fast_forward)
    
func _on_toggle_fast_forward():
    fast_forward_state = (fast_forward_state + 1) % FastForwardSpeed.size()

    # Apply the corresponding time scale
    match fast_forward_state:
        FastForwardSpeed.SPEED_1X:
            Engine.time_scale = 1.0
            fast_forward_ui.update_debug_label("1x")
        FastForwardSpeed.SPEED_2X:
            Engine.time_scale = 2.0
            fast_forward_ui.update_debug_label("2x")
        FastForwardSpeed.SPEED_3X:
            Engine.time_scale = 3.0
            fast_forward_ui.update_debug_label("3x")
        FastForwardSpeed.SPEED_4X:
            Engine.time_scale = 4.0
            fast_forward_ui.update_debug_label("4x")
