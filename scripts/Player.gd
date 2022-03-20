extends KinematicBody2D


onready var speed       = get_parent().move_speed
onready var blast_range = get_parent().blast_range
onready var bomb_amount = get_parent().bomb_amount
onready var fuse_time   = get_parent().fuse_time


var player_num       :  int
var allow_place_bomb := true
var stand_on_bomb    := false
var bomb_num         :  int
var velocity         := Vector2()
var score            :  int




func _ready():
	z_index = 2



func _physics_process(_dt):
	var direction := Vector2.ZERO

	if Input.is_action_pressed("left"+str(player_num)):
		direction.x -= 1
	if Input.is_action_pressed("right"+str(player_num)):
		direction.x += 1

	if Input.is_action_pressed("up"+str(player_num)):
		direction.y -= 1
	elif Input.is_action_pressed("down"+str(player_num)):
		direction.y += 1

	if Input.is_action_pressed("shoot"+str(player_num)) and allow_place_bomb and not stand_on_bomb:
		if bomb_num < bomb_amount:
			bomb_num += 1
			place_bomb()

	if direction != Vector2.ZERO:
		direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, .6)
	velocity = move_and_slide(velocity)
	position += velocity

	#### CHECK FOR BLAST COLLISION
	for coll in get_slide_count():
		var collider = get_slide_collision(coll).collider
		var check = 2 if player_num == 1 else 1

#		if collider
#		if collider.is_in_group("blast".left(5)):

		for group in collider.get_groups():
			if "blast" == group.left(5):
				$DeathSound.play()
#				$CollisionShape2D.disabled = true

				if group == "blast"+str(check):
					get_parent().get_node("Player"+str(check)).score += 1
					death()
					break
				else:
					get_parent().get_node("Player"+str(player_num)).score -= 1
					death()
					break




func death():
	get_parent().reset()




func place_bomb():
	var bomb      : KinematicBody2D = get_parent()._bomb.instance()
	var tile_size : int             = get_parent().tile_size

	allow_place_bomb = false
	get_parent().add_child(bomb)
	var x = stepify(position.x, tile_size)
	var y = stepify(position.y, tile_size)
	x = x + tile_size / 2 if position.x > x else x - tile_size / 2
	y = y + tile_size / 2 if position.y > y else y - tile_size / 2
	bomb.position    = Vector2(x, y)
	bomb.player_num  = player_num
	bomb.get_node("Sprite").modulate = get_parent().get("player"+str(player_num)+"_tint")
	bomb.get_node("Timer").wait_time = fuse_time
	bomb.get_node("Timer").start()
	bomb.blast_range = blast_range
	$BombDelay.start()




func _on_BombDelay_timeout():
	allow_place_bomb = true


func _on_BombCheck_area_shape_entered(_a,_b,_c,_d):
	stand_on_bomb = true
#	print("entered")


func _on_BombCheck_area_shape_exited(_a,_b,_c,_d):
	stand_on_bomb = false
#	print("exit")


func _on_BlastCheck_area_shape_entered(_a, _b, _c, _d):
	print("DED!")


func _on_BonusCheck_area_shape_entered(_a, area, _c, _d):
	match area.bonus:
		0:
			bomb_amount += 1
		1:
			blast_range += 1
	area.queue_free()
