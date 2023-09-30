class_name MapObject extends Node2D

var data: Dictionary

func create(position: Vector2, scene: String, data: Dictionary):
	self.position = position
	_set_data(scene, data)

func _set_data(scene: String, data: Dictionary):
	self.data = data
	self.data['type'] = scene
