class_name SceneTransition extends CanvasLayer

@onready var anim: AnimationPlayer = $SceneTransitionAnimationPlayer

var transitioning: bool

func begin_transition():
	transitioning = true
	anim.play_backwards("scale_down")

func _finish_transition():
	if transitioning:
		Global.scene_transition_finished()
