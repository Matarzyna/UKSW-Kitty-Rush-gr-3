extends Control


func _on_start_pressed() -> void:
	print("Start pressed")
	get_tree().change_scene_to_file("res://Mapa_0.tscn")


func _on_settings_pressed() -> void:
	print("Settings pressed")


func _on_exit_pressed() -> void:
	print("Exit pressed")
	get_tree().quit()
