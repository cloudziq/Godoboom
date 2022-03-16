extends KinematicBody2D


var velocity         := Vector2()
var allow_place_bomb := true
var stand_on_bomb    := false

onready var speed = get_parent().move_speed



func _ready():
	z_index = 2



func _physics_process(_dt):
	var direction := Vector2.ZERO

	if Input.is_action_pressed("left1"):
		direction.x -= 1
	if Input.is_action_pressed("right1"):
		direction.x += 1

	if Input.is_action_pressed("up1"):
		direction.y -= 1
	elif Input.is_action_pressed("down1"):
		direction.y += 1

	if Input.is_action_pressed("shoot1") and allow_place_bomb and not stand_on_bomb:
		place_bomb()

	if direction != Vector2.ZERO:
		direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, .6)
	velocity = move_and_slide(velocity)
	position += velocity




func place_bomb():
	var bomb      : RigidBody2D = get_parent()._bomb.instance()
	var tile_size : int = get_parent().tile_size

	allow_place_bomb = false
	get_parent().add_child(bomb)
	var x = stepify(position.x, floor(tile_size / 2))
	var y = stepify(position.y, floor(tile_size / 2))
	bomb.position = Vector2(x, y)
	$BombDelay.start()




func _on_BombDelay_timeout():
	allow_place_bomb = true




func _on_BombCheck_area_shape_entered(a,b,c,d):
	stand_on_bomb = true


func _on_BombCheck_area_shape_exited(a,b,c,d):
	stand_on_bomb = false
