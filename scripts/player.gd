class_name Player extends Area2D

signal drag_ended(original_pos: Vector2, new_pos: Vector2)
signal moved(new_pos: Vector2)

@onready var dragged_sprite: Sprite2D = $DraggedSprite
@onready var level: Level = $"../Level"
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var blood: CPUParticles2D = $BloodParticles
@onready var footsteps1: AudioStreamPlayer = $Footsteps1
@onready var footsteps2: AudioStreamPlayer = $Footsteps2
@onready var ladder_sfx: AudioStreamPlayer = $LadderSFX
@onready var unlock_sfx: AudioStreamPlayer = $UnlockSFX
@onready var snake_sfx: AudioStreamPlayer = $SnakeSFX
@onready var key_sfx: AudioStreamPlayer = $KeySFX
@onready var apple_sfx: AudioStreamPlayer = $AppleSFX
@onready var ui = $"/root/UI"
@onready var cursor: Cursor = $"/root/UI/Cursor"

var grabbed: bool
var original_pos: Vector2
var lerp_to_pos: Vector2

var keys: int
var apples: int

func _ready():
	original_pos = position
	lerp_to_pos = position
	dragged_sprite.visible = false
	ui.on_new_scene_ready()
	
func _process(delta):
	if grabbed:
		var tile_pos = level.local_to_map(get_global_mouse_position())
		var player_map_pos = Vector2(level.local_to_map(position))
		var dir_to_tile_pos = player_map_pos.direction_to(tile_pos)
	
		match dir_to_tile_pos:
			Vector2.UP: dragged_sprite.rotation_degrees = -90
			Vector2.DOWN: dragged_sprite.rotation_degrees = 90
			Vector2.LEFT: dragged_sprite.rotation_degrees = 180
			Vector2.RIGHT: dragged_sprite.rotation_degrees = 0

		var valid_direction = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT].has(dir_to_tile_pos)
		dragged_sprite.visible = valid_direction and !level.is_blocked(player_map_pos + dir_to_tile_pos)
	else:
		dragged_sprite.visible = false
		position = position.lerp(lerp_to_pos, 20 * delta)
	
func _input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and not event.is_pressed() \
			and grabbed:
		grabbed = false
		drag_ended.emit(original_pos, get_global_mouse_position())
		cursor.stop_dragging()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed() \
			and not Global.is_game_paused():
		original_pos = position
		grabbed = true
		cursor.start_dragging()

func set_new_pos(new_pos: Vector2):
	Global.moves += 1

	lerp_to_pos = new_pos
	moved.emit(lerp_to_pos)
	if randi()%2 == 0:
		footsteps1.play()
	else:
		footsteps2.play()

func _on_area_entered(area):
	if level.is_same_tile(lerp_to_pos, area.get_parent().position) or area.is_in_group("arrows"):
		if area.is_in_group("keys"):
			keys += 1
			area.get_parent().queue_free()
			key_sfx.play()

		if area.is_in_group("apples"):
			apples += 1
			area.get_parent().queue_free()
			apple_sfx.play()

		if area.is_in_group("hazards"):
			if area.is_in_group("trap doors"):
				anim.play("trap_door")
			elif area.is_in_group("snakes"):
				snake_sfx.play()
				emit_blood()
			else:
				emit_blood()

			Global.call_deferred("kill_player")

func emit_blood():
	blood.emitting = true

func play_ladder_anim():
	anim.play("up_ladder")

func play_ladder_sfx():
	ladder_sfx.play()
	
func play_unlock_sfx():
	unlock_sfx.play()
