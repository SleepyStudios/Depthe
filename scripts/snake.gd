class_name Snake extends MapObject

@onready var player: Player = $"../Player"
@onready var level: Level = $"../Level"
@onready var sprite: Sprite2D = $Sprite

var dir = Vector2(0, 16)
var horizontal = false

func _ready():
	player.moved.connect(_on_player_moved)

	horizontal = data.get("horizontal", false)
	if horizontal:
		sprite.rotation_degrees = 270
		dir = Vector2(16, 0)

func _on_player_moved(new_pos: Vector2):
	if level.is_blocked(level.local_to_map(position + dir)):
		dir *= -1
		sprite.flip_v = !sprite.flip_v

	var original_pos = position
	position += dir
	sprite.flip_h = !sprite.flip_h

	if level.is_same_tile(player.original_pos, position) and level.is_same_tile(new_pos, original_pos):
		position = new_pos
