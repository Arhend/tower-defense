extends Panel

const TowerColor = preload("res://Scenes/Towers/base_tower.gd").TowerColor

@onready var toggle_priority_button = $Grid/ContentRows/TogglePriorityButton
@onready var damage_count_label = $Grid/ContentRows/BottomContentRow/DamageCountLabel
@onready var close_tower_detail_button = $"../CloseTowerDetailButton"
@onready var tower_color_label = $Grid/ContentRows/TowerColorLabel

var tower: BaseTower

func _ready():
    SignalManager.on_tower_clicked.connect(_on_tower_clicked)
    SignalManager.on_tower_damage_dealt.connect(_on_tower_damage_dealt)
    hide_details()
    
func hide_details():
    hide()
    tower = null
    close_tower_detail_button.hide()
    
func update_priority_text():
    var priority_string = BaseTower.TargetPriorities.keys()[tower.targeting_priority]
    toggle_priority_button.text = priority_string.capitalize()
    
func update_damage_count_text():
    var num_str = str(tower.tower_stats.damage_count)
    var regex = RegEx.new()
    regex.compile("\\B(?=(\\d{3})+(?!\\d))")
    damage_count_label.text = regex.sub(num_str, ",", true)
    
func _on_sell_button_pressed():
    SignalManager.on_gold_earned.emit(tower.tower_stats.cost / 2)
    tower.queue_free()
    hide_details()
    
func _on_tower_clicked(clicked_tower: BaseTower):
    tower = clicked_tower
    update_priority_text()
    update_damage_count_text()
    tower_color_label.text = tower.get_tower_color()
    
    LoggerManager.debug("Tower %s Color: %s" % [tower.name, tower.get_tower_color()])
    show()
    close_tower_detail_button.show()

func _on_hide_details_button_pressed():
    hide_details()

func _on_toggle_priority_button_pressed():
    tower.toggle_priority()
    update_priority_text()

func _on_tower_damage_dealt(registered_tower: BaseTower):
    if tower and registered_tower == tower:
        update_damage_count_text()

func _on_close_tower_detail_button_pressed():
    hide_details()


func _on_red_paint_button_pressed():
    tower.set_tower_color(TowerColor.RED)
    tower_color_label.text = tower.get_tower_color()

func _on_blue_paint_button_pressed():
    tower.set_tower_color(TowerColor.BLUE)
    tower_color_label.text = tower.get_tower_color()
    
func _on_green_paint_button_pressed():
    tower.set_tower_color(TowerColor.GREEN)
    tower_color_label.text = tower.get_tower_color()
