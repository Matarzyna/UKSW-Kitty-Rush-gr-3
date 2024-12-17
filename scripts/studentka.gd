extends CharacterBody2D
@export var tile_size = 16  # Rozmiar kafelka (w pikselach)
@export var move_time = 0.3  # Czas ruchu w sekundach
@onready var animated_sprite_2d = $AnimatedSprite2D  # Ścieżka do AnimatedSprite2D
@onready var ray = $RayCast2D

var face_direction = "Right"
var is_moving = false  # Flaga kontrolująca, czy postać obecnie się porusza
var move_direction = Vector2.ZERO  # Kierunek ruchu
var move_timer = 0.0  # Licznik czasu dla ruchu
var start_position = Vector2.ZERO  # Pozycja początkowa ruchu

var death_position = Vector2(-104,80) #Pozycja checkpointu

func _physics_process(delta):
	if is_moving:
		move_timer += delta
		var progress = move_timer / move_time
		if progress >= 1.0:
			progress = 1.0
			is_moving = false

		var velocity = move_direction * tile_size / move_time
		var collision = move_and_collide(velocity * delta)  # Sprawdź kolizję podczas ruchu
		if collision:
			if collision.get_collider().is_in_group("Killzone"):  # Grupa Killzone
				force_death()
	else:
		handle_input()


		

func handle_input():
	if Input.is_action_pressed("ui_up"):
		ray.set_target_position(Vector2.UP * 16)
		ray.force_raycast_update()
		if !ray.is_colliding():
			if(face_direction == "Right"):
				start_movement(Vector2.UP, "clime_r")
			else:
				start_movement(Vector2.UP, "clime_l")
	elif Input.is_action_pressed("ui_down"):
		ray.set_target_position(Vector2.DOWN * 16)
		ray.force_raycast_update()
		if !ray.is_colliding():
			if(face_direction == "Right"):
				start_movement(Vector2.DOWN, "clime_r")
			else:
				start_movement(Vector2.DOWN, "clime_l")
	elif Input.is_action_pressed("ui_left"):
		ray.set_target_position(Vector2.LEFT * 16)
		ray.force_raycast_update()
		if !ray.is_colliding():
			face_direction = "Left"
			start_movement(Vector2.LEFT, "walk_l")
	elif Input.is_action_pressed("ui_right"):
		ray.set_target_position(Vector2.RIGHT * 16)
		ray.force_raycast_update()
		if !ray.is_colliding():
			face_direction = "Right"
			start_movement(Vector2.RIGHT, "walk_r")
	else:
		if(face_direction == "Right"):
			animated_sprite_2d.play("stay_r")
		else:
			animated_sprite_2d.play("stay_l")

func start_movement(direction: Vector2, animation: String):
	is_moving = true
	move_direction = direction
	move_timer = 0.0
	start_position = global_position
	animated_sprite_2d.play(animation)

func reset_to_checkpoint():
	global_position = death_position

func force_death():
	reset_to_checkpoint()
	
