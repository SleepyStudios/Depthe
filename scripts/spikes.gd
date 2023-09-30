class_name Spikes extends MapObject

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D

func toggle():
	sprite.frame = (0 if sprite.frame == 1 else 1)
	if sprite.frame == 0:
		area.remove_from_group("hazards")
	else:
		area.add_to_group("hazards")
