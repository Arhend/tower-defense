extends ColorRect

class_name PauseMenuUi

var prev_time_scale: float

func _ready():
    # Not calling hide_pause_menu here since we don't 
    # want to update the time scale
    hide()

func show_pause_menu():
    if visible:
        return
        
    prev_time_scale = Engine.time_scale
    Engine.time_scale = 0
    show()
    
func hide_pause_menu():
    Engine.time_scale = prev_time_scale
    hide()

func _on_close_pause_menu_button_pressed():
    hide_pause_menu()
