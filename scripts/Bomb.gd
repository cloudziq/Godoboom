extends RigidBody2D




func _ready():
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("bomb_ignited")
	$Timer.start()




func _on_Area2D_body_exited(body):
	print("exited")
	$CollisionShape2D.set_deferred("disabled", false)
