class_name Level extends TileMap

@onready var player: Player = $"../Player"

func _ready():
	player.drag_ended.connect(_on_player_drag_ended)
	player.moved.connect(_on_player_moved)
	_replace_tiles_with_scenes()
	
func _replace_tiles_with_scenes():
	for layer_id in range(get_layers_count()):
		for tile_pos in get_used_cells(layer_id):
			var data = get_cell_tile_data(layer_id, tile_pos)
			if data and data.get_custom_data("scene"):
				set_cell(layer_id, tile_pos, -1)

				var scene_name = data.get_custom_data("scene")
				var scene = load("res://scenes/map_objects/%s.tscn" % [scene_name])

				var obj = scene.instantiate()
				obj.create(map_to_local(tile_pos), scene_name, data.get_custom_data("map_object_data"))
				get_parent().add_child.call_deferred(obj)

func _is_diagonal(original_pos: Vector2, new_pos: Vector2) -> bool:
	var dir = original_pos.direction_to(new_pos).abs()
	return dir.x == dir.y

func _get_layer_by_name(layer_name: String) -> int:
	for layer_id in range(get_layers_count()):
		if get_layer_name(layer_id) == layer_name:
			return layer_id
	return -1

func _get_collision_layer() -> int:
	return _get_layer_by_name('Collision')

func _on_player_drag_ended(original_pos: Vector2, new_pos: Vector2):
	var local_original_pos = Vector2(local_to_map(original_pos))
	var local_new_pos = Vector2(local_to_map(new_pos))

	if not _is_diagonal(local_original_pos, local_new_pos):
		var dir = local_original_pos.direction_to(local_new_pos)
		var next_pos = local_original_pos + dir

		if not is_blocked(next_pos):
			player.set_new_pos(map_to_local(next_pos))

func is_blocked(pos: Vector2) -> bool:
	var data = get_cell_tile_data(_get_collision_layer(), pos)
	var blocked = data.get_custom_data("blocked") if data else false
	var requires_key = data.get_custom_data("requires_key") if data else false

	if blocked and requires_key:
		if player.keys > 0:
			player.keys -= 1
			blocked = false
			set_cell(_get_collision_layer(), pos, -1)

	return blocked

func is_same_tile(pos1: Vector2, pos2: Vector2) -> bool:
	return local_to_map(pos1) == local_to_map(pos2)

func _on_player_moved(new_pos: Vector2):
	var data = get_cell_tile_data(_get_layer_by_name("Interactables"), local_to_map(new_pos))
	if data:
		match data.get_custom_data("interaction"):
			"ladder": print("next level")

func add_blocked_tile(pos: Vector2):
	set_cell(_get_collision_layer(), local_to_map(pos), 0, Vector2i(4, 1))
