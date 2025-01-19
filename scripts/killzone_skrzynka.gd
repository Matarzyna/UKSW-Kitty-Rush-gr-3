extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("wrogowie"):
		body.queue_free()
	elif body.is_in_group("player"):
		print("You get hit")
		print("You died")
		body.notify_game_manager_force_death()
	
