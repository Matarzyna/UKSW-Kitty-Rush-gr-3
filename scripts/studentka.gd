extends CharacterBody2D
@export var tile_size = 16  # Rozmiar kafelka (w pikselach)
@export var move_time = 0.3  # Czas ruchu w sekundach
@onready var animated_sprite_2d = $AnimatedSprite2D  # Ścieżka do AnimatedSprite2D
@onready var ray = $RayCast2D

var life = 5
var globalLife = 5
var face_direction = "right"
var is_moving = false  # Flaga kontrolująca, czy postać obecnie się porusza
var move_direction = Vector2.ZERO  # Kierunek ruchu
var move_timer = 0.0  # Licznik czasu dla ruchu
var start_position = Vector2.ZERO  # Pozycja początkowa ruchu

var death_position = Vector2(-104,80) #Pozycja checkpointu
var is_destroy = false
var is_lost_hp = false


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
				life -= 1;
				check_life()
				if(life == 0):
					force_death()
				
	elif is_destroy:
			is_destroy = false
	else:
		handle_input()


		

func handle_input():
	if Input.is_action_pressed("ui_up"):
		ray.set_target_position(Vector2.UP * 16)
		ray.force_raycast_update()
		if !ray.is_colliding():
			if(face_direction == "right"):
				start_movement(Vector2.UP, "clime_r")
			else:
				start_movement(Vector2.UP, "clime_l")
		elif Input.is_action_pressed("ui_accept"):
			start_attack(face_direction)
	
	elif Input.is_action_pressed("ui_down"):
		ray.set_target_position(Vector2.DOWN * 16)
		ray.force_raycast_update()
		if !ray.is_colliding():
			if(face_direction == "right"):
				start_movement(Vector2.DOWN, "clime_r")
			else:
				start_movement(Vector2.DOWN, "clime_l")
		elif Input.is_action_pressed("ui_accept"):
			start_attack(face_direction)
	
	elif Input.is_action_pressed("ui_left"):
		ray.set_target_position(Vector2.LEFT * 16)
		ray.force_raycast_update()
		face_direction = "left"
		if !ray.is_colliding():
			start_movement(Vector2.LEFT, "walk_l")
		elif Input.is_action_pressed("ui_accept"):
			start_attack(face_direction)
	
	elif Input.is_action_pressed("ui_right"):
		ray.set_target_position(Vector2.RIGHT * 16)
		ray.force_raycast_update()
		face_direction = "right"
		if !ray.is_colliding():
			start_movement(Vector2.RIGHT, "walk_r")
		elif Input.is_action_pressed("ui_accept"):
			start_attack(face_direction)
	
	else:
		if (face_direction == "right"):
			animated_sprite_2d.play("stay_r")
		else:
			animated_sprite_2d.play("stay_l")
	
func start_attack(direction: String):
	var collider = ray.get_collider()
	if collider.is_in_group('bushs'):
		if(direction == "left"):
			animated_sprite_2d.play("destroy_l")
		else:
			animated_sprite_2d.play("destroy_r")
		is_destroy = true
		move_timer = 0.0
		collider.body_entered()

func start_movement(direction: Vector2, animation: String):
	is_moving = true
	move_direction = direction
	move_timer = 0.0
	start_position = global_position
	animated_sprite_2d.play(animation)

func reset_to_checkpoint():
	global_position = death_position

func force_death():
	life = 5
	globalLife -= 1
	var text = str(globalLife)
	$"../CanvasLayer"/Container/HBoxContainer2/AnimatedSprite2D5.play("default")
	$"../CanvasLayer"/Container/HBoxContainer2/AnimatedSprite2D4.play("default")
	$"../CanvasLayer"/Container/HBoxContainer2/AnimatedSprite2D3.play("default")
	$"../CanvasLayer"/Container/HBoxContainer2/AnimatedSprite2D2.play("default")
	$"../CanvasLayer"/Container/HBoxContainer2/AnimatedSprite2D.play("default")
	$"../CanvasLayer"/Container/HBoxContainer3/AnimatedSprite2D.play(text)
	reset_to_checkpoint()


func check_life():
	if(life == 4):
		$"../CanvasLayer"/Container/HBoxContainer2/AnimatedSprite2D5.play("nothing")
	elif(life == 3):
		$"../CanvasLayer"/Container/HBoxContainer2/AnimatedSprite2D4.play("nothing")
	elif(life == 2):
		$"../CanvasLayer"/Container/HBoxContainer2/AnimatedSprite2D3.play("nothing")
	elif(life == 1):
		$"../CanvasLayer"/Container/HBoxContainer2/AnimatedSprite2D2.play("nothing")
	elif(life == 0):
		$"../CanvasLayer"/Container/HBoxContainer2/AnimatedSprite2D.play("nothing")
