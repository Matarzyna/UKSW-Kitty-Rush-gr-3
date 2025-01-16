extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.death_position = global_position  # Ustawienie pozycji checkpointu
		print("Checkpoint ustawiony na pozycji: ",global_position)
		
		SaveManager.save_game()
