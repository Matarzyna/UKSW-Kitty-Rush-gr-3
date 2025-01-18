extends Area2D

var is_collected = false

func _on_body_entered(_body: Node2D) -> void:
	if is_collected:
		return
	is_collected = true
	if Global.life < 5:
		Global.life += 1
		
		var game_manager = get_tree().get_nodes_in_group("GameManager")[0]
		if game_manager and game_manager.has_method("update_ui_life"):
			game_manager.check_life(Global.life)
		else:
			print("Nie znaleziono GameManager lub brak metody update_ui_life")
	
	$CollisionShape2D.call_deferred("set_disabled", true)
	call_deferred("set_visible", false)
	print(name, "Serce zebrane. Aktualne życie:", Global.life)
	

func set_state(state):
	is_collected = state.get("is_collected", false)
	visible = state.get("visible", true)
	$CollisionShape2D.disabled = is_collected
	set_visible(visible)
	print("Stan serca ustawiony:", name, "is_collected:", is_collected, "visible:", visible)
