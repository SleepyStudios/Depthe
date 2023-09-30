extends TileMap

@export var player: Player

func _ready():
	player.drag_ended.connect(_on_player_drag_ended)

func _is_diagonal(original_pos: Vector2, new_pos: Vector2) -> bool:
	var dir = original_pos.direction_to(new_pos).abs()
	return dir.x == dir.y

func _on_player_drag_ended(original_pos: Vector2, new_pos: Vector2):
	var local_original_pos = Vector2(local_to_map(original_pos))
	var local_new_pos = Vector2(local_to_map(new_pos))

	if not _is_diagonal(local_original_pos, local_new_pos):
		var dir = local_original_pos.direction_to(local_new_pos)
		var next_pos = local_original_pos + dir

		var data = get_cell_tile_data(0, next_pos)
		if data and not data.get_custom_data("blocked"):
			player.set_new_pos(map_to_local(next_pos))
