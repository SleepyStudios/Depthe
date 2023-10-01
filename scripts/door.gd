class_name Door extends MapObject

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var level: Level = $"../Level"

@export var open = false

func _ready():
	sprite.frame = 1 if open else 0
	_toggle_tile()

func toggle():
	sprite.frame = (0 if sprite.frame == 1 else 1)
	_toggle_tile()

func _toggle_tile():
	if sprite.frame == 0:
		level.add_blocked_tile(position, Vector2(4, 4))
	else:
		level.clear_blocked_tile(position)
