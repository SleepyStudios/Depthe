extends CanvasLayer

@onready var scene_anim: AnimationPlayer = $SceneTransitionAnimationPlayer
@onready var tutorial: Label = $Tutorial
@onready var tutorial_anim: AnimationPlayer = $TutorialAnimationPlayer
@onready var cursor: Cursor = $Cursor

var transitioning: bool
var tutorial_dismissed: bool
var restarting: bool

func _get_player() -> Player:
	var path = "../Level/Player"
	return get_node(path) if has_node(path) else null

func _on_player_moved(_new_pos):
	if Global.current_level == 1 and not tutorial_dismissed:
		tutorial_anim.play_backwards("fade_in")
		tutorial_dismissed = true

func _unhandled_input(event):
	if event.is_action_pressed("restart") and not restarting \
		and not transitioning \
		and not Global.is_game_paused() \
		and Global.current_level > 0 and Global.current_level < Global.max_level:
		restarting = true
		get_tree().call_deferred("reload_current_scene")
		restarting = false

	if event.is_action_pressed("fullscreen") and not OS.has_feature("web"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	if event.is_action_pressed("quit"):
		get_tree().quit()

func begin_transition():
	if transitioning:
		return

	transitioning = true
	scene_anim.play("scale_up")

func _finish_transition():
	if transitioning:
		Global.scene_transition_finished()
		transitioning = false

func on_new_scene_ready():
	restarting = false
	scene_anim.play("scale_down")

	if Global.current_level == 1:
		tutorial.text = "Click and drag the player to move"
		tutorial_anim.play("fade_in")

	if _get_player():
		_get_player().moved.connect(_on_player_moved)
