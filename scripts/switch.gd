class_name Switch extends MapObject

@onready var sprite = $AnimatedSprite2D

func _on_area_2d_area_entered(_area):
	sprite.frame = (0 if sprite.frame == 1 else 1)
