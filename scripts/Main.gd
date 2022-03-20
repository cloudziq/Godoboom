extends Node2D


export var move_speed   := 1.6
export var fuse_time    := 3.0
export var bomb_delay   := 0.25
export var bomb_amount  := 2
export var blast_range  := 2
export var mob_amount   := 4
export var player1_tint := Color(.4, .4, 1)
export var player2_tint := Color(.4, 1, .4)

var tile_size       := 32
#var free_cells     :  Array
#var blast_color_def := Color(1,1,1)
var color_speed     := 0.004

onready var speed1 := move_speed
onready var _bomb  := preload("res://scenes/Bomb.tscn")
onready var _blast := preload("res://scenes/Blast.tscn")




func _ready():
	randomize()
#	Utils.window_prepare()
#	get_walkable_tiles()
	reset()
	$Player1.player_num = 1
	$Player1/Sprite.modulate = Color(.6, .6, 1.4)
	$Player2/Sprite.modulate = Color(.6, 1.4, .6)
	$Player2.player_num = 2
	position.y += 46

#	for a in mob_amount:
#		var inst = _mob.instance()
#		add_child(inst)




func _process(_dt):
	var color = $Level.tile_set.tile_get_modulate(1).b

	color += color_speed
	if color < .8 or color >= 1:
		color_speed = -color_speed
	else:
		$Level.tile_set.tile_set_modulate(1, Color(color, color, color))




func reset(full := false):
	if full == false:
		var bounds = $Level.get_used_rect().size
		$Player1.position = Vector2(1, 1) * 32
		$Player2.position = Vector2(bounds.x - 1, bounds.y - 1) * 32

		$Player1/BombDelay.wait_time = bomb_delay
		$Player2/BombDelay.wait_time = bomb_delay
	else:
		for player in 2:
			var node = get_node("Player"+str(player))
			node.score       = 0
			node.speed       = move_speed
			node.bomb_amount = bomb_amount
			node.blast_range = blast_range




#func get_walkable_tiles():
#	var cells = $Level.get_used_rect().size
#
#	free_cells.clear()
#	for x in cells.x:
#		for y in cells.y:
#			if $Level.get_cell(x, y) < 0: free_cells.append([x, y])
