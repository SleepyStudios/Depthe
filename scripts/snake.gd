class_name Snake extends MapObject

@onready var player: Player = $"../Player"
@onready var level: Level = $"../Level"

var dir = 16

func _ready():
	player.moved.connect(_on_player_moved)

func _on_player_moved(_new_pos: Vector2):
	if level.is_blocked(level.local_to_map(position + Vector2(0, dir))):
		dir *= -1

	position.y += dir
