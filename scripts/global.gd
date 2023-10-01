extends Node

var apples_collected = 0
var current_level = 1

func _get_player():
	return get_node("../Level/Player")

func next_level():
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
	get_tree().call_deferred("reload_current_scene")
