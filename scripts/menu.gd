extends Control

var pause_canvas = null

func set_pause_canvas(canvas):
	pause_canvas = canvas

func reset_kitty_counter():
	var kitty_counter = get_node("/root/Levels/GameManager")
	if kitty_counter != null:
		kitty_counter.reset_cat_count()
		print("Cat counter reset successfully.")
	else:
		print("Kitty_Counter node not found! Cannot reset cat count.")

func _on_start_pressed() -> void:
	print("Start pressed")
	get_tree().change_scene_to_file("res://Mapa_0.tscn")

func _on_continue_pressed() -> void:
	print("Continue pressed")
	
func _on_restart_pressed() -> void:
	print("Restart pressed")
	reset_kitty_counter()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Mapa_0.tscn")

func _on_menu_pressed() -> void:
	print("Menu pressed")
	reset_kitty_counter()
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

func _on_resume_pressed() -> void:
	print("Resume pressed")
	if pause_canvas:
		pause_canvas.resume()
	else:
		print("PauseCanvas not found!")
		
func _on_pause_button_pressed() -> void:
	print("Pause pressed")
	if pause_canvas:
		pause_canvas.pause()
	else:
		print("PauseCanvas not found!")
