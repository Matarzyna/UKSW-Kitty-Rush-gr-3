extends Control

func _on_start_pressed() -> void:
	print("Start pressed")
	get_tree().change_scene_to_file("res://Mapa_0.tscn")

func _on_continue_pressed() -> void:
	print("Continue pressed")
	
func _on_restart_pressed() -> void:
	print("Restart pressed")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Mapa_0.tscn")

func _on_menu_pressed() -> void:
	print("Menu pressed")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")
	
func _on_settings_pressed() -> void:
	print("Settings pressed")

func _on_credits_pressed() -> void:
	print("Credits pressed")

func _on_exit_pressed() -> void:
	print("Exit pressed")
	get_tree().paused = false
	get_tree().quit()
