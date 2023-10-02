extends AudioStreamPlayer2D

var next_timeout: float
var tmr_check: float

func _ready():
	_pick_next_timeout()

func _pick_next_timeout():
	next_timeout = randf_range(2.0, 25.0)

func _process(delta):
	tmr_check += delta
	if tmr_check >= next_timeout:
		volume_db = randf_range(-30, -20)
		pitch_scale = randf_range(0.85, 1.15)
		play()

		_pick_next_timeout()
		tmr_check = 0
