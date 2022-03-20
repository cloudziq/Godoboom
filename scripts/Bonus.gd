extends Area2D

#signal bonus(type)
onready var bonus = randi() % bonuses.size()


var bonuses = [
	preload("res://assets/graphics/bonuses/bomb.png"),
	preload("res://assets/graphics/bonuses/range.png")
]




func _ready():
	$Sprite.texture = bonuses[bonus]
