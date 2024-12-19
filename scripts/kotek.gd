extends Area2D

@onready var game_manager: Node = %GameManager

func _on_body_entered(body: Node2D) -> void:
	game_manager.add_cat_count()  
	queue_free()
