extends KinematicBody2D


onready var tile_size   : int     = get_parent().tile_size
onready var level       : TileMap = get_parent().get_node("Level")
onready var blast       : TileMap = get_parent()._blast.instance()

var explode_sound := [
	load("res://assets/sounds/explode1.wav"),
	load("res://assets/sounds/explode2.wav")
]

var _bomb_collider = preload("res://scenes/BombCollider.tscn")

var alpha            := 1.0
var blast_fade_delay := 0.0
var can_explode      := true
var player_num       :  int
var blast_range      :  int
#var collider_table   := []




func _ready():
	set_process(false)
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("bomb_ignited")
	add_to_group("bomb"+str(player_num))
	$BombSpawn.pitch_scale = rand_range(.9, 1.2)
	$BombSpawn.play()
#	$Timer.start()




func _process(dt):
#	print($BlastCollisionCheck.get_overlapping_bodies())
	if OS.get_system_time_msecs() > blast_fade_delay:
		alpha -= 0.04
		blast_fade_delay = OS.get_system_time_msecs() + 10 * dt
		blast.tile_set.tile_set_modulate(0, Color(1,1,1, alpha))
		if alpha <= 0.08:
			blast.free()
			set_process(false)
			yield($Explosion, "finished")
			queue_free()




#func _physics_process(_dt):
#	pass
#	print($BlastCollisionCheck.get_overlapping_bodies())
#	print($CollisionShape2D.disabled)
#	for coll in get_slide_count():
#		print(get_slide_collision(coll).collider.name)
#		if get_slide_collision(coll).collider.name == "Blast":
#			$CollisionShape2D.set_deferred("disabled", true)
#			explode()




func explode():
	var coord           = (position / tile_size).floor()
	var cells_to_blast := [coord]
	var directions     := [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

	$BlastCollisionCheck.set_deferred("monitoring", false)
	$InitCollisionCheck.set_deferred("monitoring", false)
	$CollisionShape2D.set_deferred("disabled", true)

	for direction in directions:
		coord = (position / tile_size).floor() + direction

		for cell in blast_range:
			var actual_cell = level.get_cellv(coord)

			var obj = _bomb_collider.instance()
			get_parent().add_child(obj)
			obj.position = (coord + Vector2(.5, .5)) * tile_size
#			collider_table.append(obj)

			if actual_cell != 0:
				cells_to_blast.append(coord)
				if actual_cell == 1:
					bonus_spawn(coord)
					level.set_cellv(coord, -1)
					break
			else:
				break
			coord += direction

	for cell in cells_to_blast:
		blast.set_cellv(cell, 0)
		blast.update_bitmask_area(cell)

	get_parent().add_child(blast)
	blast.update_dirty_quadrants()
	blast.add_to_group("blast"+str(player_num))
	can_explode = false
	get_parent().get_node("Player"+str(player_num)).bomb_num -= 1
	$Explosion.stream = explode_sound[randi() % explode_sound.size()]
	$Explosion.play()
	set_process(true)
	hide()




func bonus_spawn(coord):
	if randf() <= .8:
#		emit_signal()
		var bonus = load("res://scenes/Bonus.tscn").instance()
		get_parent().add_child(bonus)
		bonus.position = coord * tile_size + (Vector2(tile_size, tile_size) / 2)
#		print(bonus.bonus_process())




func _on_InitCollisionCheck_body_exited(_body):
	$CollisionShape2D.set_deferred("disabled", false)
	$InitCollisionCheck.set_deferred("monitoring", false)


func _on_BlastCollisionCheck_area_entered(area: Area2D):
	$Timer.stop()
	area.delete()
	yield(get_tree().create_timer(.01), "timeout")
	if can_explode: explode()


#func _on_BlastCollisionCheck_body_entered(_body):
#	print($BlastCollisionCheck.get_overlapping_bodies())
#	$Timer.stop()
#	explode()


func _on_Timer_timeout():
	explode()
