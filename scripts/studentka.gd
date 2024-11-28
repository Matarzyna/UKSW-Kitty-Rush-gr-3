

extends CharacterBody2D
@export var tile_size = 16  # Rozmiar kafelka (w pikselach)
@export var move_time = 0.5  # Czas ruchu w sekundach
@onready var animated_sprite_2d = $AnimatedSprite2D  # Ścieżka do AnimatedSprite2D
@onready var ray = $RayCast2D

var is_moving = false  # Flaga kontrolująca, czy postać obecnie się porusza
var move_direction = Vector2.ZERO  # Kierunek ruchu
var move_timer = 0.0  # Licznik czasu dla ruchu
var start_position = Vector2.ZERO  # Pozycja początkowa ruchu


func _physics_process(delta):
	if is_moving:
		# Kontynuuj ruch
		move_timer += delta
		var progress = move_timer / move_time
		if progress >= 1.0:
			progress = 1.0
			is_moving = false  # Ruch zakończony

		# Interpoluj między pozycją startową a końcową
		global_position = start_position + move_direction * tile_size * progress
	else:
		# Sprawdź wejście gracza
		handle_input()

func handle_input():
	if Input.is_action_just_pressed("ui_up"):
		ray.set_target_position(Vector2.UP * 16)
		ray.force_raycast_update()
		if !ray.is_colliding():
			start_movement(Vector2.UP, "up")
	elif Input.is_action_just_pressed("ui_down"):
		ray.set_target_position(Vector2.DOWN * 16)
		ray.force_raycast_update()
		if !ray.is_colliding():
			start_movement(Vector2.DOWN, "face_down")
	elif Input.is_action_just_pressed("ui_left"):
		ray.set_target_position(Vector2.LEFT * 16)
		ray.force_raycast_update()
		if !ray.is_colliding():
			start_movement(Vector2.LEFT, "left")
	elif Input.is_action_just_pressed("ui_right"):
		ray.set_target_position(Vector2.RIGHT * 16)
		ray.force_raycast_update()
		if !ray.is_colliding():
			start_movement(Vector2.RIGHT, "right")

func start_movement(direction: Vector2, animation: String):
	is_moving = true
	move_direction = direction
	move_timer = 0.0
	start_position = global_position
	animated_sprite_2d.play(animation)

	








	
