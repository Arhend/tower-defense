extends Control

class_name MainMenu

const FOREST = "res://Scenes/Levels/Forest/forest.tscn"

func _on_play_button_pressed():
    pass # Replace with function body.
    SceneManager.change_scene(FOREST)
