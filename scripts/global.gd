extends Node

var apples_collected = 0
var current_level = 1

func _get_player():
	return get_node("../Level%s/Player" % [current_level])

func next_level():
	apples_collected += _get_player().apples
	current_level += 1
	
	var new_scene = load("res://scenes/levels/level_%s.tscn" % [current_level]) 
	get_tree().root.add_child(new_scene.instantiate())
	get_tree().root.get_node("Level%s" % [current_level - 1]).queue_free()

func kill_player():
	get_tree().reload_current_scene()
