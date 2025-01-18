extends Node2D

@onready var life_chest_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var life_chest_area_2d: Area2D = $Area2D

var is_opening := false
var is_opened := false
var is_player_nearby := false  # Flaga, która informuje, czy gracz jest w pobliżu

# Ścieżka do sceny serca
const HEART_SCENE_PATH := "res://Heart.tscn"
var heart_scene: PackedScene = preload(HEART_SCENE_PATH)

func _ready() -> void:
	life_chest_area_2d.body_entered.connect(_on_body_entered)
	life_chest_area_2d.body_exited.connect(_on_body_exited)
	
	if Global.chests_state.has(name):
		var state = Global.chests_state[name]
		set_state(state)
	else:
		life_chest_sprite.play("closed")  # Ustaw stan początkowy

func _on_body_entered(body: Node) -> void:
	if body.name == "Studentka":
		is_player_nearby = true  # Gracz jest w pobliżu

func _on_body_exited(body: Node) -> void:
	if body.name == "Studentka":
		is_player_nearby = false  # Gracz opuścił obszar

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_chest") and is_player_nearby and not is_opened and not is_opening:
		_open_chest()

func _open_chest() -> void:
	is_opening = true
	life_chest_sprite.play("opening")  # Odtwórz animację otwierania
	var animation_length = life_chest_sprite.sprite_frames.get_frame_count("opening") / life_chest_sprite.sprite_frames.get_animation_speed("opening")
	await get_tree().create_timer(animation_length).timeout
	life_chest_sprite.play("opened")  # Przejdź do stanu otwartego
	is_opened = true
	is_opening = false

	# Twórz serce po otwarciu skrzyni
	_spawn_heart()

func _spawn_heart() -> void:
	var heart_instance = heart_scene.instantiate()
	heart_instance.position = global_position + Vector2(0, 0)
	get_parent().add_child(heart_instance)
	
func set_state(state):
	is_opened = state.get("is_opened", false)
	if is_opened:
		$AnimatedSprite2D.play("opened")  # Ustaw stan otwartej skrzyni
	else:
		$AnimatedSprite2D.play("closed")  # Ustaw stan zamkniętej skrzyni
	print("Stan skrzyni ustawiony:", name, "is_opened:", is_opened)
