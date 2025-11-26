extends Node

signal on_enemy_reached_exit(enemy: BaseEnemy)
signal on_all_lives_lost

signal on_enemy_deactivated(enemy: BaseEnemy)

signal on_gold_earned(value: int)
signal on_gold_removed(value: int)
signal on_gold_updated(total_gold: int)

signal on_start_next_wave()
signal on_toggle_autostart_waves(toggle: bool)

signal on_toggle_fast_forward()

signal on_tower_clicked(tower: BaseTower)
signal on_tower_damage_dealt(tower: BaseTower)
