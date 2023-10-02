extends Node2D

var next_timeout: float
var tmr_check: float

func _ready():
  _pick_next_timeout()

func _pick_next_timeout():
  next_timeout = randf_range(1.0, 45.0)

func _process(delta):
  tmr_check += delta
  if tmr_check >= next_timeout:
    _choose_ambience()
    tmr_check = 0

func _choose_ambience():
  var rand_index = randi_range(0, get_child_count() - 1)

  if not get_child(rand_index).playing:
    get_child(rand_index).volume_db = randf_range(-40, -30)
    get_child(rand_index).pitch_scale = randf_range(0.9, 1.1)
    get_child(rand_index).play()

  _pick_next_timeout()
