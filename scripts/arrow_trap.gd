class_name ArrowTrap extends MapObject

@onready var level: Level = $"../Level"
@onready var area: Area2D = $Area2D
@onready var arrow = $Arrow
@onready var player: Player = $"../Player"
@onready var ray: RayCast2D = $RayCast2D

var will_fire = false
var original_arrow_pos: Vector2

func _ready():
	player.moved.connect(_on_player_moved)
	arrow.visible = false
	original_arrow_pos = arrow.position

func _on_player_moved(_new_pos: Vector2):
	if will_fire and not arrow.visible:
		arrow.visible = true
		will_fire = false

func _process(delta):
	if ray.is_colliding() and not arrow.visible and not will_fire:
		will_fire = true

	if arrow.visible and not Global.is_game_paused():
		arrow.position += Vector2.DOWN * 150.0 * delta
		var map_pos = level.local_to_map(arrow.global_position)
		if level.is_blocked(map_pos) and not level.is_water(map_pos):
			reset_arrow()

func reset_arrow():
	arrow.visible = false
	arrow.position = original_arrow_pos
	will_fire = false
