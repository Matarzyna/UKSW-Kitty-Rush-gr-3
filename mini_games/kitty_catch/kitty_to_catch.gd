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
