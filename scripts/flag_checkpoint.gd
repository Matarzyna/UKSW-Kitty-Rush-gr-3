extends Area2D

var game_manager = null

func _ready() -> void:
	game_manager = get_tree().get_nodes_in_group("GameManager")[0]

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.death_position = global_position  # Ustawienie pozycji checkpointu
		print("Checkpoint ustawiony na pozycji: ",global_position)
		save_lifes(body)
		if game_manager.has_method("save_game_state"):
			game_manager.save_game_state()

func save_lifes(body):
	# Uzyskanie referencji do GameManager
	if game_manager:
		# Przypisanie wartości globalLife i life z gracza do GameManager
		game_manager.globalLife = body.globalLife
		game_manager.life = body.life
		# Zapisanie stanu gry (jeśli metoda istnieje)
		print("Zapisano stan gry: globalLife =", game_manager.globalLife, ", life =", game_manager.life)
