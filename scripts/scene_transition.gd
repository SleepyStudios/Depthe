class_name SceneTransition extends CanvasLayer

@onready var scene_anim: AnimationPlayer = $SceneTransitionAnimationPlayer
@onready var tutorial: Label = $Tutorial
@onready var tutorial_anim: AnimationPlayer = $TutorialAnimationPlayer
@onready var player: Player = $"../Player"

var transitioning: bool
var tutorial_dismissed: bool

func _ready():
	player.moved.connect(_on_player_moved)
	if Global.current_level == 1:
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
