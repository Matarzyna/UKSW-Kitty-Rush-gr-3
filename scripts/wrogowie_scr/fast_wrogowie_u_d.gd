extends Node2D

const NORMAL_SPEED = 40      # Normalna prędkość
const CHASE_SPEED = 60       # Przyspieszona prędkość
const DETECTION_RANGE = 30  # Zasięg wykrywania postaci

var direction = -1
var player = null  # Referencja do postaci gracza
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Pobierz gracza z grupy 'player'
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		print("Nie znaleziono gracza w grupie 'player'!")
		
func _process(delta: float) -> void:
	var speed = NORMAL_SPEED
	
	# Sprawdź odległość do gracza
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance <= DETECTION_RANGE:
			speed = CHASE_SPEED  # Przyspiesz, jeśli gracz jest blisko
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

	if ray_cast_up.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
	if ray_cast_down.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
	position.y+= direction * speed * delta
