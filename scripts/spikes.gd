class_name Spikes extends MapObject

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D
@onready var player: Player = $"../Player"

func _ready():
	player.moved.connect(_on_player_moved)

func _on_player_moved(_new_pos):
	sprite.frame = (sprite.frame + 1) % sprite.sprite_frames.get_frame_count("default")

	if sprite.frame == sprite.sprite_frames.get_frame_count("default") - 1:
		area.add_to_group("hazards")
	else:
		area.remove_from_group("hazards")
