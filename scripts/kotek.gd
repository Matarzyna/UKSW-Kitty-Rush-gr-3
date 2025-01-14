extends Area2D

var is_collected: bool = false

func _on_body_entered(_body: Node2D) -> void:
	if is_collected:
		return  # Przerwij, jeśli już zebrano
	is_collected = true
	
	Global.cat_counter += 1
	print("Kitty: ", Global.cat_counter)
	
	$CollisionShape2D.call_deferred("set_disabled", true)
	call_deferred("set_visible", false)
