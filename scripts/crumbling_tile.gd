class_name CrumblingTile extends MapObject

@onready var sprite = $AnimatedSprite2D
@onready var level: Level = $"../Level"

var crumbled: bool

func _on_area_2d_area_exited(_area):
	if crumbled:
		return

	crumbled = true
	sprite.play("default")
	level.add_blocked_tile(position)
