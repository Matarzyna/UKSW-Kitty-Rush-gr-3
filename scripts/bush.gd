extends StaticBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@export var move_time = 0.3
@onready var colision_shape_2d = $CollisionShape2D
var is_destroy = false
var move_timer = 0.0 

func _physics_process(delta):
	if is_destroy:
		colision_shape_2d.disabled = true
		move_timer += delta
		var progress = move_timer / move_time
		if progress >= 1.0:
			progress = 1.0
			is_destroy = false
			queue_free()
	
	
func body_entered():
	animated_sprite_2d.play("destroy")
	is_destroy = true
	move_timer = 0.0
