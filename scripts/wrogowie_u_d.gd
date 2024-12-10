extends Node2D

const SPEED = 40

var direction = -1
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_up: RayCast2D = $RayCastUp

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_up.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
	if ray_cast_down.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
	position.y+= direction * SPEED * delta
