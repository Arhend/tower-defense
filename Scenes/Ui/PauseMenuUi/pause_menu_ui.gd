extends ColorRect

class_name PauseMenuUi

const MAIN_MENU = "res://Scenes/MainMenu/main_menu.tscn"

enum ConfirmModalActions {
    NONE,
    RESTART,
    EXIT_TO_MAIN_MENU
}

@onready var confirm_panel = $ConfirmPanel
@onready var confirm_label = $ConfirmPanel/VBoxContainer/ConfirmLabel

var prev_time_scale: float
var confirm_action: ConfirmModalActions = ConfirmModalActions.NONE

func _ready():
    # Not calling hide_pause_menu here since we don't 
    # want to update the time scale
    hide()

func show_pause_menu():
    if visible:
        return
        
    prev_time_scale = Engine.time_scale
    Engine.time_scale = 0
    
    confirm_panel.hide()
    show()
    
func hide_pause_menu():
    Engine.time_scale = prev_time_scale
    hide()

func show_confirm_modal(action: ConfirmModalActions):
    confirm_action = action
    confirm_panel.show()
    
    match action:
        ConfirmModalActions.RESTART:
            confirm_label.text = "Are you sure you wish to restart this map?"
        ConfirmModalActions.EXIT_TO_MAIN_MENU:
            confirm_label.text = "Are you sure you wish to exit to the main menu?"

        _:
            confirm_label.text = "What action was this?"

func _on_close_pause_menu_button_pressed():
    hide_pause_menu()

func _on_restart_level_button_pressed():
    show_confirm_modal(ConfirmModalActions.RESTART)
    
func _on_cancel_button_pressed():
    confirm_panel.hide()
    confirm_action = ConfirmModalActions.NONE

func _on_exit_to_main_menu_button_pressed():
    show_confirm_modal(ConfirmModalActions.EXIT_TO_MAIN_MENU)

func _on_confirm_button_pressed():
    match confirm_action:
        ConfirmModalActions.RESTART:
            Engine.time_scale = 1
            SceneManager.reload_current_scene()
        ConfirmModalActions.EXIT_TO_MAIN_MENU:
            Engine.time_scale = 1
            SceneManager.change_scene(MAIN_MENU)
