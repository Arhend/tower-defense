extends Sprite2D


func _on_delete_timer_timeout():
    queue_free()


func _on_area_2d_area_entered(area):
    LoggerManager.debug("Enemy entered base paint blob")
    # TODO: Need to add logic for each paint blob color to
    # do something neat
