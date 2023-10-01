class_name TrapDoor extends MapObject

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var level: Level = $"../Level"
@onready var area: Area2D = $Area2D

@export var open = false

func toggle():
	sprite.frame = (0 if sprite.frame == 1 else 1)
	if sprite.frame == 1:
		area.add_to_group("hazards")
	else:
		area.remove_from_group("hazards")
