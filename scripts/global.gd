extends Node

var current_level = 1
var apples_collected = 0
var time = 0
var deaths = 0
var moves = 0
var max_level = 1

var player_is_dead: bool
var go_to_next_level: bool

@onready var ui = $"../UI"

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)

	var base_path = "res://scenes/levels"
	var dir = DirAccess.open(base_path)
	dir.list_dir_begin()

	var file_name = dir.get_next()
	while file_name != "":
		if file_name.begins_with("level_"):
			max_level += 1
		file_name = dir.get_next()

func _get_player() -> Player:
	return get_node("../Level/Player")

func _process(delta):
	if not is_game_paused():
		time += delta

func next_level():
	if not go_to_next_level:
		go_to_next_level = true
		ui.begin_transition()
		return

	go_to_next_level = false

	apples_collected += _get_player().apples
	current_level += 1

	var scene_name = "end" if current_level == max_level else "level_%s" % [current_level]
	var new_scene = load("res://scenes/levels/%s.tscn" % [scene_name])
	var old_scene = get_tree().root.get_node("Level")
	old_scene.name = "_"

	var new_scene_instance = new_scene.instantiate()
	get_tree().get_root().add_child(new_scene_instance)
	get_tree().set_current_scene(new_scene_instance)
	old_scene.queue_free()
	ui.on_new_scene_ready()

func kill_player():
	if not player_is_dead:
		player_is_dead = true
		deaths += 1
		ui.begin_transition()
		return

	player_is_dead = false

	get_tree().call_deferred("reload_current_scene")
	ui.call_deferred("on_new_scene_ready")

func scene_transition_finished():
	if player_is_dead:
		kill_player()
	if go_to_next_level:
		next_level()

func is_game_paused() -> bool:
	return player_is_dead or go_to_next_level
