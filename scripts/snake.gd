class_name Snake extends MapObject

@onready var player: Player = $"../Player"
@onready var level: Level = $"../Level"
@onready var sprite: Sprite2D = $Sprite

var dir = 16

func _ready():
	player.moved.connect(_on_player_moved)

func _on_player_moved(new_pos: Vector2):
	if level.is_blocked(level.local_to_map(position + Vector2(0, dir))):
		dir *= -1
		sprite.flip_v = !sprite.flip_v

	var original_pos = position
	position.y += dir

	if level.is_same_tile(player.original_pos, position) and level.is_same_tile(new_pos, original_pos):
		Global.kill_player()
