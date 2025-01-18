#extends Node2D
#
#@onready var game_chest_sprite: AnimatedSprite2D = $gameChestSprite
#@onready var game_chest_area_2d: Area2D = $gameChestArea2D
#
#var is_opening := false
#var is_opened := false
#
#func _ready() -> void:
	## Połącz zdarzenie wykrycia gracza z funkcją
	#game_chest_area_2d.body_entered.connect(_on_body_entered)
	#game_chest_sprite.play("closed")  # Ustaw stan początkowy
#
#func _on_body_entered(body: Node) -> void:
	#if body.name == "Studentka" and not is_opened and not is_opening:
		#_open_chest()
#
#func _open_chest() -> void:
	#is_opening = true
	#game_chest_sprite.play("opening")  # Odtwórz animację otwierania
	#
	## Oblicz czas trwania animacji
	#var animation_length = game_chest_sprite.sprite_frames.get_frame_count("opening") / game_chest_sprite.sprite_frames.get_animation_speed("opening")
	#
	## Poczekaj na zakończenie animacji
	#await get_tree().create_timer(animation_length).timeout
	#
	#game_chest_sprite.play("opened")  # Przejdź do stanu otwartego
	#is_opened = true
	#is_opening = false
#
	## Rozpocznij minigrę
	#_start_minigame()
#
#func _start_minigame() -> void:
	## Wczytaj scenę minigry
	#var minigame_scene = load("res://mini_games/kitty_catch/kitty_catch_game.tscn")  # Zmień ścieżkę na właściwą
	#if not minigame_scene:
		#print("Error: Failed to load minigame scene. Check the path.")
		#return
	#
	## Utwórz instancję minigry
	#var minigame_instance = minigame_scene.instantiate()
	#if not minigame_instance:
		#print("Error: Failed to instantiate minigame scene.")
		#return
#
	## Dodaj minigrę do głównego drzewa jako nakładkę
	#get_tree().root.add_child(minigame_instance)
#
	## Podłącz sygnał zakończenia minigry
	#if minigame_instance.has_signal("minigame_finished"):
		#minigame_instance.connect("minigame_finished", self, "_on_minigame_finished")
		#print("Connected to 'minigame_finished' signal.")
	#else:
		#print("Error: Minigame instance does not have the signal 'minigame_finished'.")
#
#
#
#func _on_minigame_finished() -> void:
	#print("Minigra zakończona! Dodano nagrodę.")
	## Możesz dodać nagrodę, np. zwiększenie punktów


extends Node2D

@onready var game_chest_sprite: AnimatedSprite2D = $gameChestSprite
@onready var game_chest_area_2d: Area2D = $gameChestArea2D

var is_opening: bool = false
var is_opened: bool = false

func _ready() -> void:
	game_chest_area_2d.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Studentka" and not is_opened and not is_opening:
		_open_chest()

func _open_chest() -> void:
	is_opening = true
	game_chest_sprite.play("opening")

	var animation_length = game_chest_sprite.sprite_frames.get_frame_count("opening") / game_chest_sprite.sprite_frames.get_animation_speed("opening")
	await get_tree().create_timer(animation_length).timeout

	game_chest_sprite.play("opened")
	is_opened = true
	is_opening = false

	_start_minigame()

func _start_minigame() -> void:
	var minigame_scene = load("res://mini_games/kitty_catch/kitty_catch_game.tscn")
	if not minigame_scene:
		print("Błąd: Nie udało się załadować minigry.")
		return

	var minigame_instance = minigame_scene.instantiate()
	get_tree().root.add_child(minigame_instance)

	if minigame_instance.has_signal("minigame_finished"):
		minigame_instance.connect("minigame_finished", self, "_on_minigame_finished")

func _on_minigame_finished() -> void:
	print("Minigra zakończona! Kontynuuj grę.")
	# Tutaj możesz dodać nagrodę dla gracza lub inne akcje
