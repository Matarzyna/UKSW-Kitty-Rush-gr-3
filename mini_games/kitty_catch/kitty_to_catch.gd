#extends CharacterBody2D
#
#@onready var purple_container: PanelContainer = $"../kitty_catching_game/PanelContainer/MarginContainer/VBoxContainer/PurpleContainer"
#@onready var kitty_sprite: AnimatedSprite2D = $kitty_sprite
#@onready var kitty_size: Vector2 = Vector2(64, 64)
#
#const SPEED = 300.0
#const BORDER_DISTANCE = 10.0
#const TARGET_REACHED_THRESHOLD = 5.0  # Minimalna odległość uznawana za dotarcie do celu
#
#var target_position: Vector2 = Vector2.ZERO
#
#func _ready() -> void:
	## Ustaw rozmiar kota na podstawie pierwszej ramki animacji
	#if kitty_sprite and kitty_sprite.sprite_frames:
		#if kitty_sprite.sprite_frames.has_animation("move"):
			#kitty_size = kitty_sprite.sprite_frames.get_frame_texture("move", 0).get_size() * kitty_sprite.scale
		#else:
			#print("Error: AnimatedSprite2D does not have an animation named 'move'.")
	#else:
		#print("Error: Invalid AnimatedSprite2D or sprite_frames not assigned.")
#
	## Ustaw początkową pozycję kota (ręcznie)
	#_set_start_position()
#
	## Wyznacz pierwszy cel ruchu
	#_set_new_target_position()
#
#func _physics_process(delta: float) -> void:
	#if global_position.distance_to(target_position) > TARGET_REACHED_THRESHOLD:
		## Obliczenie kierunku ruchu i nadanie prędkości
		#var direction = (target_position - global_position).normalized()
		#velocity = direction * SPEED
		#global_position += velocity * delta
		#global_position = _clamp_position_to_container(global_position)  # Ogranicz pozycję do kontenera
	#else:
		## Zatrzymanie ruchu po dotarciu do celu
		#velocity = Vector2.ZERO
		#_on_target()
#
	## Ustaw animację
	#_set_animation()
#
	## Debugowanie wartości
	#print("Global position:", global_position, "Target position:", target_position, "Velocity:", velocity)
#
#func _on_target() -> void:
	#print("Reached target position:", target_position)
	#set_physics_process(false)  # Wyłącz przetwarzanie fizyki na chwilę
	#await get_tree().create_timer(1.5).timeout
	#_set_new_target_position()
	#set_physics_process(true)  # Włącz przetwarzanie fizyki
#
#func _set_start_position() -> void:
	## Ręczna pozycja startowa kota
	#global_position = Vector2(500, 700)  # Zmień na dowolne współrzędne (np. w obrębie PurpleContainer)
#
	## Debugowanie pozycji początkowej
	#print("Start position set to:", global_position)
#
#func _set_new_target_position() -> void:
	#if not purple_container:
		#print("Error: PurpleContainer is not assigned!")
		#return
#
	#var container_rect = purple_container.get_global_rect()
#
	## Wybierz nową losową pozycję w kontenerze
	#target_position = Vector2(
		#randf_range(container_rect.position.x + BORDER_DISTANCE, container_rect.position.x + container_rect.size.x - BORDER_DISTANCE),
		#randf_range(container_rect.position.y + BORDER_DISTANCE, container_rect.position.y + container_rect.size.y - BORDER_DISTANCE)
	#)
#
	## Ogranicz pozycję celu, aby pozostała w granicach kontenera
	#target_position = _clamp_position_to_container(target_position)
	#print("New target position set to:", target_position)
#
#func _clamp_position_to_container(position: Vector2) -> Vector2:
	#if not purple_container:
		#print("Error: PurpleContainer is not assigned!")
		#return position
#
	#var container_rect = purple_container.get_global_rect()
	#var half_width = kitty_size.x / 2
	#var half_height = kitty_size.y / 2
#
	## Ogranicz pozycję kota, aby pozostał w kontenerze
	#position.x = clamp(position.x, container_rect.position.x + half_width, container_rect.position.x + container_rect.size.x - half_width)
	#position.y = clamp(position.y, container_rect.position.y + half_height, container_rect.position.y + container_rect.size.y - half_height)
#
	#return position
#
#func _set_animation() -> void:
	#if velocity.length() > 0:
		#kitty_sprite.play("move")
	#else:
		#kitty_sprite.stop()

##############################################################################

#extends CharacterBody2D
#
#@onready var kitty_sprite: AnimatedSprite2D = $kitty_sprite
#
#const SPEED: float = 300.0
#const TARGET_REACHED_THRESHOLD: float = 5.0
#
#var target_position: Vector2 = Vector2.ZERO
#var container_rect: Rect2 = Rect2()  # Prostokąt ograniczający ruch kota
#
#func _ready() -> void:
	## Automatycznie znajdź kontener nadrzędny w hierarchii i pobierz jego granice
	#var container_node = get_parent().get_node("PanelContainer/MarginContainer/VBoxContainer/PurpleContainer")
	#if container_node:
		#container_rect = container_node.get_global_rect()
	#else:
		#print("Error: PurpleContainer not found. Default bounds applied.")
		#container_rect = Rect2(Vector2(500, 250), Vector2(280, 250))  # Domyślne granice
#
	## Ustaw startową pozycję kota
	#_set_start_position()
#
	## Ustaw początkowy cel
	#_set_new_target_position()
#
#func _physics_process(delta: float) -> void:
	#if global_position.distance_to(target_position) > TARGET_REACHED_THRESHOLD:
		## Poruszaj się w kierunku celu
		#var direction = (target_position - global_position).normalized()
		#global_position += direction * SPEED * delta
#
		## Ogranicz pozycję do granic kontenera
		#global_position = _clamp_position_to_container(global_position)
	#else:
		#_set_new_target_position()
#
#func _set_start_position() -> void:
	## Wybierz początkową pozycję w granicach kontenera
	#global_position = container_rect.position + Vector2(100, 100)
#
#func _set_new_target_position() -> void:
	## Losuj nowy cel w obrębie kontenera
	#target_position = Vector2(
		#randf_range(container_rect.position.x, container_rect.position.x + container_rect.size.x),
		#randf_range(container_rect.position.y, container_rect.position.y + container_rect.size.y)
	#)
#
#func _clamp_position_to_container(position: Vector2) -> Vector2:
	## Ogranicz pozycję kota do granic kontenera
	#return Vector2(
		#clamp(position.x, container_rect.position.x, container_rect.position.x + container_rect.size.x),
		#clamp(position.y, container_rect.position.y, container_rect.position.y + container_rect.size.y)
	#)


##############################################################################

extends CharacterBody2D

@onready var kitty_sprite: AnimatedSprite2D = $kitty_sprite

const SPEED: float = 300.0
const TARGET_REACHED_THRESHOLD: float = 5.0

var target_position: Vector2 = Vector2.ZERO
var container_rect: Rect2 = Rect2()  # Prostokąt ograniczający ruch kota

func _ready() -> void:
	# Automatycznie znajdź kontener nadrzędny w hierarchii i pobierz jego granice
	var container_node = get_parent().get_node("PanelContainer/MarginContainer/VBoxContainer/PurpleContainer")
	if container_node:
		container_rect = container_node.get_global_rect()
	else:
		print("Error: PurpleContainer not found. Default bounds applied.")
		container_rect = Rect2(Vector2(500, 250), Vector2(245, 218))  # Domyślne granice

	# Ustaw startową pozycję kota
	_set_start_position()

	# Ustaw początkowy cel
	_set_new_target_position()

func _hide_kitty_temporarily() -> void:
	var timer = Timer.new()
	timer.wait_time = 2.0  # Czas ukrycia w sekundach
	timer.one_shot = true
	timer.timeout.connect(_show_kitty)
	add_child(timer)
	timer.start()

func _show_kitty() -> void:
	kitty_sprite.visible = true  # Pokazuje kota po 1 sekundzie

func _physics_process(delta: float) -> void:
	if global_position.distance_to(target_position) > TARGET_REACHED_THRESHOLD:
		# Poruszaj się w kierunku celu
		var direction = (target_position - global_position).normalized()
		global_position += direction * SPEED * delta

		# Ogranicz pozycję do granic kontenera
		global_position = _clamp_position_to_container(global_position)
	else:
		# Osiągnięto cel - wykonaj akcję
		_on_target()

func _set_start_position() -> void:
	# Wybierz początkową pozycję w granicach kontenera
	global_position = container_rect.position + Vector2(100, 100)


func _set_new_target_position() -> void:
	# Losuj nowy cel w obrębie kontenera
	target_position = Vector2(
		randf_range(container_rect.position.x, container_rect.position.x + container_rect.size.x),
		randf_range(container_rect.position.y, container_rect.position.y + container_rect.size.y)
	)

func _clamp_position_to_container(position: Vector2) -> Vector2:
	# Ogranicz pozycję kota do granic kontenera
	return Vector2(
		clamp(position.x, container_rect.position.x, container_rect.position.x + container_rect.size.x),
		clamp(position.y, container_rect.position.y, container_rect.position.y + container_rect.size.y)
	)

func _on_target() -> void:
	print("Reached target position:", target_position)

	# Wyłącz przetwarzanie fizyki na chwilę
	set_physics_process(false)

	# Wstrzymaj się na 1.5 sekundy, a następnie wykonaj nowy ruch
	await get_tree().create_timer(1.5).timeout

	# Wybierz nowy cel i włącz przetwarzanie fizyki
	_set_new_target_position()

	set_physics_process(true)