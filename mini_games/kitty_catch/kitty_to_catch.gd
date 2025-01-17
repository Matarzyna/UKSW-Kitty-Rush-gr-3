extends CharacterBody2D

@onready var purple_container: PanelContainer = $"../kitty_catching_game/PanelContainer/MarginContainer/VBoxContainer/PurpleContainer"
@onready var kitty_sprite: AnimatedSprite2D = $kitty_sprite
@onready var kitty_size: Vector2 = Vector2(64, 64)

const SPEED = 300.0
const BORDER_DISTANCE = 10.0
const TARGET_REACHED_THRESHOLD = 5.0  # Minimalna odległość uznawana za dotarcie do celu

var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Ustaw rozmiar kota na podstawie pierwszej ramki animacji
	if kitty_sprite and kitty_sprite.sprite_frames:
		if kitty_sprite.sprite_frames.has_animation("move"):
			kitty_size = kitty_sprite.sprite_frames.get_frame_texture("move", 0).get_size() * kitty_sprite.scale
		else:
			print("Error: AnimatedSprite2D does not have an animation named 'move'.")
	else:
		print("Error: Invalid AnimatedSprite2D or sprite_frames not assigned.")

	# Ukryj kota na 1 sekundę
	kitty_sprite.visible = false
	_hide_kitty_temporarily()

	# Ustaw początkową pozycję kota
	_set_start_position()

	# Wyznacz pierwszy cel ruchu
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

func _physics_process(_delta: float) -> void:
	if global_position.distance_to(target_position) > TARGET_REACHED_THRESHOLD:
		# Obliczenie kierunku ruchu i nadanie prędkości
		var direction = (target_position - global_position).normalized()
		velocity = direction * SPEED
		global_position += velocity * _delta
		global_position = _clamp_position_to_container(global_position)  # Ogranicz pozycję do kontenera
	else:
		# Zatrzymanie ruchu po dotarciu do celu
		velocity = Vector2.ZERO
		_on_target()

	# Ustaw animację
	_set_animation()

func _on_target() -> void:
	set_physics_process(false)  # Wyłącz przetwarzanie fizyki na chwilę
	await get_tree().create_timer(1.5).timeout
	_set_new_target_position()
	set_physics_process(true)  # Włącz przetwarzanie fizyki

func _set_start_position() -> void:
	if not purple_container:
		print("Error: PurpleContainer is not assigned!")
		return

	var container_rect = purple_container.get_global_rect()

	# Powtarzaj losowanie, dopóki pozycja nie znajdzie się w ramce
	while true:
		global_position = Vector2(
			randf_range(container_rect.position.x + BORDER_DISTANCE, container_rect.position.x + container_rect.size.x - BORDER_DISTANCE),
			randf_range(container_rect.position.y + BORDER_DISTANCE, container_rect.position.y + container_rect.size.y - BORDER_DISTANCE)
		)

		if container_rect.has_point(global_position):
			break  # Wyjście z pętli, gdy pozycja jest prawidłowa

func _set_new_target_position() -> void:
	if not purple_container:
		print("Error: PurpleContainer is not assigned!")
		return

	var container_rect = purple_container.get_global_rect()

	# Wybierz nową losową pozycję w kontenerze
	target_position = Vector2(
		randf_range(container_rect.position.x + BORDER_DISTANCE, container_rect.position.x + container_rect.size.x - BORDER_DISTANCE),
		randf_range(container_rect.position.y + BORDER_DISTANCE, container_rect.position.y + container_rect.size.y - BORDER_DISTANCE)
	)

	# Ogranicz pozycję celu, aby pozostała w granicach kontenera
	target_position = _clamp_position_to_container(target_position)

func _clamp_position_to_container(input_position: Vector2) -> Vector2:
	if not purple_container:
		print("Error: PurpleContainer is not assigned!")
		return input_position

	var container_rect = purple_container.get_global_rect()
	var half_width = kitty_size.x / 2
	var half_height = kitty_size.y / 2

	# Ogranicz pozycję kota, aby pozostał w kontenerze
	input_position.x = clamp(input_position.x, container_rect.position.x + half_width, container_rect.position.x + container_rect.size.x - half_width)
	input_position.y = clamp(input_position.y, container_rect.position.y + half_height, container_rect.position.y + container_rect.size.y - half_height)

	return input_position

func _set_animation() -> void:
	if velocity.length() > 0:
		kitty_sprite.play("move")
	else:
		kitty_sprite.stop()
