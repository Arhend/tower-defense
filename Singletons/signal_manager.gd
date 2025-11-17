extends Node

signal on_enemy_reached_exit(enemy: BaseEnemy)
signal on_all_lives_lost

signal on_enemy_deactivated(enemy: BaseEnemy)

signal on_gold_earned(value: int)
signal on_gold_removed(value: int)
