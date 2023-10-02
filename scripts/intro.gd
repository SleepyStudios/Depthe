extends Node2D

func _input(event):
  if event.is_action_pressed("click"):
    Global.next_level()
