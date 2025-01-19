extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.death_position = position  # Ustawienie pozycji checkpointu
		print("Checkpoint ustawiony na pozycji: ",global_position)
		Global.life = 5
		body.notify_game_manager_check_life()
		SaveManager.save_game()
