extends CanvasLayer

func _on_restart_pressed():
	print("Restart pressed")
	#get_tree().change_scene("res://Mapa_0.tscn")
	get_tree().change_scene_to_file("res://Mapa_0.tscn")

func _on_menu_pressed():
	print("Menu pressed")
	get_tree().change_scene_to_file("res://menu.tscn")
	
func _on_settings_pressed():
	print("Settings pressed")

func _on_credits_pressed():
	print("Credits pressed")

func _on_exit_pressed():
	print("Exit pressed")
	get_tree().quit()
