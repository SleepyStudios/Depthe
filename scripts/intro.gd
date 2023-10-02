extends Node2D

@onready var cursor: Cursor = $"/root/UI/Cursor"

func _input(event):
  if event.is_action_pressed("click"):
    Global.next_level()
    cursor.start_dragging()
  elif event.is_action_released("click"):
    cursor.stop_dragging()
