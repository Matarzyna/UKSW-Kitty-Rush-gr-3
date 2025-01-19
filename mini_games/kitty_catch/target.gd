extends Area2D

signal target_entered()
signal target_exited()

const SPEED := 200

var on_kitty := false
var target_tolerance := 5  # Tolerancja odległości, aby zapobiec wibracjom

@onready var purple_container: PanelContainer = $"../kitty_catching_game/PanelContainer/MarginContainer/VBoxContainer/PurpleContainer"
@onready var target_size: Vector2 = Vector2(64, 64)

func _ready() -> void:
	var sprite := $Sprite2D 
	if sprite and sprite is Sprite2D:
		target_size = sprite.texture.get_size() * sprite.scale

func _physics_process(delta: float) -> void:
	_check_on_kitty()

	# Pobranie pozycji myszy
	var mouse_position := get_global_mouse_position()

	# Oblicz kierunek ruchu
	var direction := (mouse_position - global_position).normalized()
	if global_position.distance_to(mouse_position) > target_tolerance:
		# Proponowana nowa pozycja
		var new_position := global_position + direction * SPEED * delta
		
		# Ogranicz ruch do obszaru PurpleContainer, uwzględniając rozmiar targetu
		new_position = _clamp_position_to_container(new_position)
		
		# Zaktualizuj pozycję
		global_position = new_position

func _check_on_kitty() -> void:
	# Pobierz obiekty znajdujące się w obszarze kolizji
	var bodies := get_overlapping_bodies()

	# Jeśli nie ma obiektów, resetuj `on_kitty`
	if bodies.is_empty() and on_kitty:
		on_kitty = false
		target_exited.emit()

	# Jeśli `target` koliduje z kotem, ustaw `on_kitty`
	elif not bodies.is_empty() and not on_kitty:
		on_kitty = true
		target_entered.emit()

		# Opcjonalnie: zapobiegnij natychmiastowej zmianie pozycji
		global_position = _clamp_position_to_container(global_position)

func _clamp_position_to_container(in_position: Vector2) -> Vector2:
	# Upewnij się, że kontener istnieje
	if purple_container == null:
		#print("Error: PurpleContainer is not assigned!")
		return in_position

	# Pobierz granice kontenera
	var container_rect := purple_container.get_global_rect()
	
	# Uwzględnij rozmiar targetu (aby cały obiekt pozostał w obszarze kontenera)
	var half_width := target_size.x / 2
	var half_height := target_size.y / 2

	# Ogranicz pozycję, biorąc pod uwagę rozmiar targetu
	in_position.x = clamp(in_position.x, container_rect.position.x + half_width, container_rect.position.x + container_rect.size.x - half_width)
	in_position.y = clamp(in_position.y, container_rect.position.y + half_height, container_rect.position.y + container_rect.size.y - half_height)

	return in_position
