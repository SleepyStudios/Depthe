class_name Switch extends MapObject

@onready var sprite = $AnimatedSprite2D
@export var toggleables: Array[MapObject]

func _on_area_2d_area_entered(_area):
	sprite.frame = (0 if sprite.frame == 1 else 1)
	for toggleable in toggleables:
		if toggleable.has_method("toggle"):
			toggleable.toggle()
