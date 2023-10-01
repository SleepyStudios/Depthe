class_name ArrowTrap extends MapObject

@onready var level: Level = $"../Level"
@onready var area: Area2D = $Area2D
@onready var arrow = $Arrow
@onready var player: Player = $"../Player"

var will_fire = false
var original_arrow_pos: Vector2
var toggle_hold = false

func _ready():
	player.moved.connect(_on_player_moved)
	arrow.visible = false
	original_arrow_pos = arrow.position

func toggle():
	if toggle_hold:
		toggle_hold = false
		return

	will_fire = true
	toggle_hold = true

func _on_player_moved(_new_pos: Vector2):
	if will_fire and not arrow.visible:
		arrow.visible = true
		will_fire = false

func _process(delta):
	if arrow.visible and not Global.is_game_paused():
		arrow.position += Vector2.DOWN * 150.0 * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	arrow.visible = false
	arrow.position = original_arrow_pos
	will_fire = false
