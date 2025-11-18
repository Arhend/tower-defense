extends ColorRect

var tower: BaseTower

func _ready():
    SignalManager.on_tower_clicked.connect(_on_tower_clicked)
    hide_details()
    
func hide_details():
    hide()
    tower = null

func _on_sell_button_pressed():
    SignalManager.on_gold_earned.emit(tower.cost / 2)
    tower.queue_free()
    hide_details()
    
func _on_tower_clicked(clicked_tower: BaseTower):
    tower = clicked_tower
    show()


func _on_hide_details_button_pressed():
    hide_details()
