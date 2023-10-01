extends CanvasLayer

@onready var scene_anim: AnimationPlayer = $SceneTransitionAnimationPlayer
@onready var tutorial: Label = $Tutorial
@onready var tutorial_anim: AnimationPlayer = $TutorialAnimationPlayer

var transitioning: bool
var tutorial_dismissed: bool

func _get_player() -> Player:
	return get_node("../Level/Player")

func _ready():
	_get_player().moved.connect(_on_player_moved)
	tutorial.text = "Click and drag the player to move"
	tutorial_anim.play("fade_in")

func _on_player_moved(_new_pos):
	if Global.current_level == 1 and not tutorial_dismissed:
		tutorial_anim.play_backwards("fade_in")
		tutorial_dismissed = true

func begin_transition():
	transitioning = true
	scene_anim.play_backwards("scale_down")

func _finish_transition():
	if transitioning:
		Global.scene_transition_finished()
		_get_player().moved.connect(_on_player_moved)
		scene_anim.play("scale_down")
