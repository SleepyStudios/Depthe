class_name Player extends Area2D

signal drag_ended(original_pos: Vector2, new_pos: Vector2)
signal moved(new_pos: Vector2)

@onready var dragged_sprite: Sprite2D = $DraggedSprite
@onready var level: Level = $"../Level"
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var blood: GPUParticles2D = $BloodParticles
@onready var sfx: AudioStreamPlayer = $SFX

var grabbed: bool
var original_pos: Vector2
var lerp_to_pos: Vector2

var keys: int
var apples: int

func _ready():
	original_pos = position
	lerp_to_pos = position
	dragged_sprite.visible = false
	
func _process(delta):
	if grabbed:
		dragged_sprite.visible = true

		var tile_pos = level.local_to_map(get_global_mouse_position())
		var dir_to_tile_pos = Vector2(level.local_to_map(position)).direction_to(tile_pos)
	
		match dir_to_tile_pos:
			Vector2.UP: dragged_sprite.rotation_degrees = -90
			Vector2.DOWN: dragged_sprite.rotation_degrees = 90
			Vector2.LEFT: dragged_sprite.rotation_degrees = 180
			Vector2.RIGHT: dragged_sprite.rotation_degrees = 0
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

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed() \
			and not Global.is_game_paused():
		original_pos = position
		grabbed = true

func set_new_pos(new_pos: Vector2):
	lerp_to_pos = new_pos
	moved.emit(lerp_to_pos)
	sfx.play()

func _on_area_entered(area):
	if level.is_same_tile(lerp_to_pos, area.get_parent().position) or area.is_in_group("arrows"):
		if area.is_in_group("keys"):
			keys += 1
			area.get_parent().queue_free()

		if area.is_in_group("apples"):
			apples += 1
			area.get_parent().queue_free()

		if area.is_in_group("hazards"):
			if area.is_in_group("trap doors"):
				anim.play("trap_door")
			else:
				emit_blood()

			Global.kill_player()

func emit_blood():
	blood.emitting = true

func play_ladder_anim():
	anim.play("up_ladder")
