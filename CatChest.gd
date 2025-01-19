extends Node2D

@onready var cat_chest_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cat_chest_area_2d: Area2D = $Area2D

var is_opening := false
var is_opened := false
var is_player_nearby := false  # Flaga, która informuje, czy gracz jest w pobliżu

# Ścieżka do sceny serca
const CAT_SCENE_PATH := "res://gruby_kot.tscn"
var Cat_scene: PackedScene = preload(CAT_SCENE_PATH)

func _ready() -> void:
	if Cat_scene == null:
		print("Bład kota")
	cat_chest_area_2d.body_entered.connect(_on_body_entered)
	cat_chest_area_2d.body_exited.connect(_on_body_exited)
	
	if Global.chests_state.has(name):
		var state = Global.chests_state[name]
		set_state(state)
	else:
		cat_chest_sprite.play("ClosedCat")  # Ustaw stan początkowy

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
	cat_chest_sprite.play("OpeningCat")  # Odtwórz animację otwierania
	var animation_length = cat_chest_sprite.sprite_frames.get_frame_count("OpeningCat") / cat_chest_sprite.sprite_frames.get_animation_speed("opening")
	await get_tree().create_timer(animation_length).timeout
	cat_chest_sprite.play("OpenedCat")  # Przejdź do stanu otwartego
	is_opened = true
	is_opening = false
	# Twórz kota po otwarciu skrzyni
	_spawn_cat()

func _spawn_cat() -> void:
	var CatChest_instance = Cat_scene.instantiate()
	CatChest_instance.position = global_position + Vector2(0, 0)
	print("Pozycja kota:", CatChest_instance.position)
	get_parent().add_child(CatChest_instance)
	
func set_state(state):
	is_opened = state.get("is_opened", false)
	if is_opened:
		$AnimatedSprite2D.play("OpenedCat")  # Ustaw stan otwartej skrzyni
	else:
		$AnimatedSprite2D.play("ClosedCat")  # Ustaw stan zamkniętej skrzyni
	print("Stan skrzyni ustawiony:", name, "is_opened:", is_opened)
