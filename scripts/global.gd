extends Node

var apples_collected = 0
var current_level = 1

var player_is_dead: bool
var go_to_next_level: bool

func _get_player() -> Player:
	return get_node("../Level/Player")

func _get_scene_transition_animation_player() -> SceneTransition:
	return get_node("../Level/UI")

func next_level():
	if not go_to_next_level:
		go_to_next_level = true
		_get_scene_transition_animation_player().begin_transition()
		return

	go_to_next_level = false

	apples_collected += _get_player().apples
	current_level += 1
	
	var new_scene = load("res://scenes/levels/level_%s.tscn" % [current_level])
	var old_scene = get_tree().root.get_node("Level")
	old_scene.name = "_"

	var new_scene_instance = new_scene.instantiate()
	get_tree().get_root().add_child(new_scene_instance)
	get_tree().set_current_scene(new_scene_instance)
	old_scene.queue_free()

func kill_player():
	if not player_is_dead:
		player_is_dead = true
		_get_scene_transition_animation_player().begin_transition()
		return

	player_is_dead = false

	get_tree().call_deferred("reload_current_scene")

func scene_transition_finished():
	if player_is_dead:
		kill_player()
	if go_to_next_level:
		next_level()

func is_game_paused() -> bool:
	return player_is_dead or go_to_next_level
