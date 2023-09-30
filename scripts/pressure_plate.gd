class_name PressurePlate extends MapObject

@onready var sprite = $AnimatedSprite2D
@export var spikes: Spikes

func _ready():
	sprite.play("default")

func _on_area_2d_area_entered(_area):
	sprite.frame = (0 if sprite.frame == 1 else 1)
	if sprite.frame == 1:
		spikes.toggle()
