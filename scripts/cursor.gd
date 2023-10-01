class_name Cursor extends AnimatedSprite2D

func _ready():
	set_frame_and_progress(1, 1)
	if OS.has_feature("web"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func _process(_delta):
	position = get_viewport().get_mouse_position()

func start_dragging():
	set_frame_and_progress(0, 0)

func stop_dragging():
	set_frame_and_progress(1, 1)