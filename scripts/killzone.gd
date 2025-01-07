extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.life -= 1;
	body.notify_game_manager_check_life()
	print("You get hit")
	if(body.life == 0):
		print("You died")
		body.notify_game_manager_force_death()
