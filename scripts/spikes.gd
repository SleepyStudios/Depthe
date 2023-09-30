class_name Spikes extends MapObject

@onready var sprite = $AnimatedSprite2D
@onready var collision = $Area2D/CollisionShape2D

func toggle():
	sprite.frame = (0 if sprite.frame == 1 else 1)
	collision.set_deferred("disabled", sprite.frame == 0)
