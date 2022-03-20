extends Area2D


func delete():
	$Timer.stop()
	queue_free()




func _on_Timer_timeout():
	delete()
