extends Node

var current_scene: Node = null

func _ready():
    # Capture the starting scene (e.g., MainMenu)
    current_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)

func change_scene(scene_path: String):
    var new_scene = load(scene_path).instantiate()
    if current_scene:
        current_scene.queue_free()
    current_scene = new_scene
    get_tree().root.add_child(current_scene)
