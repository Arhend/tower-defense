extends ColorRect

@onready var toggle_priority_button = $VBoxContainer/TogglePriorityButton

var tower: BaseTower

func _ready():
    SignalManager.on_tower_clicked.connect(_on_tower_clicked)
    hide_details()
    
func hide_details():
    hide()
    tower = null

func update_priority_text():
    var priority_string = BaseTower.TargetPriorities.keys()[tower.targeting_priority]
    toggle_priority_button.text = str(priority_string)
    
func _on_sell_button_pressed():
    SignalManager.on_gold_earned.emit(tower.cost / 2)
    tower.queue_free()
    hide_details()
    
func _on_tower_clicked(clicked_tower: BaseTower):
    tower = clicked_tower
    update_priority_text()
    show()

func _on_hide_details_button_pressed():
    hide_details()

func _on_toggle_priority_button_pressed():
    tower.toggle_priority()
    update_priority_text()
