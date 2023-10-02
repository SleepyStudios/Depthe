extends Node2D

@onready var time: Label = $CanvasLayer/Stats/Time/Label
@onready var apples: Label = $CanvasLayer/Stats/Apples/Label
@onready var moves: Label = $CanvasLayer/Stats/Moves/Label
@onready var deaths: Label = $CanvasLayer/Stats/Deaths/Label

func _ready():
  var minutes = Global.time / 60
  var seconds = fmod(Global.time, 60)
  time.text = "%02d:%02d" % [minutes, seconds]
  apples.text = str(Global.apples_collected) + "/8"
  moves.text = str(Global.moves)
  deaths.text = str(Global.deaths)
