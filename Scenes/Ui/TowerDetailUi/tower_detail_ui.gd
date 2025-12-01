extends Panel

const TowerColor = preload("res://Scenes/Towers/base_tower.gd").TowerColor
const NO_LEVEL: Color = Color.BLACK
const HAS_LEVEL: Color = Color.WHITE

@onready var toggle_priority_button = $Grid/ContentRows/TogglePriorityButton
@onready var damage_count_label = $Grid/ContentRows/BottomContentRow/DamageCountLabel
@onready var close_tower_detail_button = $"../CloseTowerDetailButton"
@onready var tower_color_label = $Grid/ContentRows/TowerColorLabel
@onready var tower_purchase_service = $"../../Services/TowerPurchaseService"
@onready var upgrade_price_label = $Grid/ContentRows/UpgradeVbox/UpgradePriceLabel
@onready var upgrade_button = $Grid/ContentRows/UpgradeVbox/UpgradeButton
@onready var upgrade_icons_hbox = $Grid/ContentRows/UpgradeVbox/UpgradeIconsHbox
@onready var gold_service = $"../../Services/GoldService"
@onready var tower_texture = $Grid/ContentRows/TowerTexture

var tower: BaseTower

func _ready():
    SignalManager.on_tower_clicked.connect(_on_tower_clicked)
    SignalManager.on_tower_damage_dealt.connect(_on_tower_damage_dealt)
    SignalManager.on_gold_updated.connect(_on_gold_updated)
    hide_details()
    
func hide_details():
    hide()
    tower = null
    close_tower_detail_button.hide()
    
func update_priority_text():
    var priority_string = BaseTower.TargetPriorities.keys()[tower.targeting_priority]
    toggle_priority_button.text = priority_string.capitalize()
    
func refresh_upgrade_icons():
    var children = upgrade_icons_hbox.get_children()
    var tower_level = tower.tower_level

    for i in range(children.size()):
        if i < tower_level:
            children[i].modulate = HAS_LEVEL
        else:
            children[i].modulate = NO_LEVEL
    
    if tower.is_max_level():
        upgrade_price_label.text = "MAX"
    else:
        upgrade_price_label.text = "%d" % tower.get_upgrade_cost()
    
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
    if tower_purchase_service.is_placing():
        return
    
    tower = clicked_tower
    update_priority_text()
    update_damage_count_text()
    tower_color_label.text = tower.get_tower_color()
    
    if tower.can_upgrade_tower(gold_service):
        upgrade_button.disabled = false
    else:
        upgrade_button.disabled = true
        
    tower_texture.texture = tower.get_tower_texture()
    refresh_upgrade_icons()
    
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


func _on_upgrade_button_pressed():
    if !tower.can_upgrade_tower(gold_service):
        return
        
    SignalManager.on_gold_removed.emit(tower.get_upgrade_cost())
    tower.upgrade_tower_level()
    refresh_upgrade_icons()

func _on_gold_updated(_total_gold: int):
    if tower and is_visible():
        upgrade_button.disabled = not tower.can_upgrade_tower(gold_service)
