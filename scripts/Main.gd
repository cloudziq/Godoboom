extends Node2D


export var move_speed := 1.6
export var fuse_time  := 4
export var bomb_delay := 1
export var mob_amount := 4

var tile_size       := 32
#var half_tile       := Vector2(tile_size, tile_size) / 2
var free_cells      :  Array
var tile_color_def  := Color(1,1,1)
var color_speed     := 0.004

onready var speed1 := move_speed
onready var _bomb  := preload("res://scenes/Bomb.tscn")




func _ready():
	randomize()
	get_walkable_tiles()
	reset()

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




func reset():
	$Player1.position = Vector2(1, 1) * 32
#	get_tree().call_group("apple", "spawn")




func get_walkable_tiles():
	var cells = $Level.get_used_rect().size

	free_cells.clear()
	for x in cells.x:
		for y in cells.y:
			if $Level.get_cell(x, y) < 0: free_cells.append([x, y])
