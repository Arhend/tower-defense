extends Panel

@onready var toggle_priority_button = $Grid/ContentRows/TogglePriorityButton
@onready var damage_count_label = $Grid/ContentRows/BottomContentRow/DamageCountLabel

var tower: BaseTower

func _ready():
    SignalManager.on_tower_clicked.connect(_on_tower_clicked)
    SignalManager.on_tower_damage_dealt.connect(_on_tower_damage_dealt)
    hide_details()
    
func hide_details():
    hide()
    tower = null

func update_priority_text():
    var priority_string = BaseTower.TargetPriorities.keys()[tower.targeting_priority]
    toggle_priority_button.text = priority_string.capitalize()
    
func update_damage_count_text():
    var num_str = str(tower.tower_stats.damage_count)
    var regex = RegEx.new()
    regex.compile("\\B(?=(\\d{3})+(?!\\d))")
    damage_count_label.text = regex.sub(num_str, ",", true)
    
func _on_sell_button_pressed():
    SignalManager.on_gold_earned.emit(tower.cost / 2)
    tower.queue_free()
    hide_details()
    
func _on_tower_clicked(clicked_tower: BaseTower):
    tower = clicked_tower
    update_priority_text()
    update_damage_count_text()
    show()

func _on_hide_details_button_pressed():
    hide_details()

func _on_toggle_priority_button_pressed():
    tower.toggle_priority()
    update_priority_text()

func _on_tower_damage_dealt(registered_tower: BaseTower):
    if tower and registered_tower == tower:
        update_damage_count_text()
