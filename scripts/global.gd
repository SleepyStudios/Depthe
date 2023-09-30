extends Node

var apples_collected = 0
var current_level = 1

func _get_player():
	return get_node('../Level/Player')

func next_level():
	apples_collected += _get_player().apples
	current_level += 1
	
	var new_scene = load("res://scenes/levels/%s.tscn" % [current_level]) 
	get_tree().root.add_child(new_scene.instantiate())

func kill_player():
	get_tree().reload_current_scene()
