extends Control

var pause_canvas = null

func set_pause_canvas(canvas):
	Global.pause_menu = canvas

func reset_kitty_counter():
	var kitty_counter = get_node("/root/Levels/CanvasLayerKC/Kitty counter")
	if kitty_counter != null:
		kitty_counter.reset_cat_count()
		print("Cat counter reset successfully.")
	else:
		print("Kitty_Counter node not found! Cannot reset cat count.")
		
func reset_life():
	Global.globalLife = 5
	Global.life = 5

func _on_start_pressed() -> void:
	print("Start pressed")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Mapa_0.tscn")

func _on_continue_pressed() -> void:
	print("Continue pressed")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	
func _on_restart_pressed() -> void:
	print("Restart pressed")
	reset_kitty_counter()
	get_tree().paused = false
	Global.set_paused(false)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Mapa_0.tscn")

func _on_menu_pressed() -> void:
	print("Menu pressed")
	get_tree().paused = false
	Global.set_paused(false)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	
	reset_kitty_counter()
	reset_life()
	
	get_tree().change_scene_to_file("res://menu.tscn")
	
func _on_settings_pressed() -> void:
	print("Settings pressed")
	save_current_scene()
	get_tree().change_scene_to_file("res://Options/options_menu.tscn")

func _on_credits_pressed() -> void:
	print("Credits pressed")
	get_tree().change_scene_to_file("res://credits_menu.tscn")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished

func _on_exit_pressed() -> void:
	print("Exit pressed")
	get_tree().paused = false
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().quit()

func _on_resume_pressed() -> void:
	print("Resume pressed")
	if Global.pause_menu:
		Global.pause_menu.resume()
	else:
		print("PauseCanvas not found!")


func _on_pause_button_pressed() -> void:
	print("Pause pressed")
	if Global.pause_menu:
		Global.pause_menu.pause()
	else:
		print("PauseCanvas not found!")


func _on_back_pressed() -> void:
	print("Back pressed")
	get_tree().change_scene_to_file("res://menu.tscn")
		
func _on_exit_button_pressed():
	print("Exit pressed")
	load_previous_scene()

func save_current_scene():
	if get_tree().current_scene:
		Global.current_scene_state = get_tree().current_scene.duplicate()
		Global.current_scene_state.name = get_tree().current_scene.name
		print("Bieżąca scena została zapisana.", Global.current_scene_state.name)
	else:
		print("Nie można zapisać bieżącej sceny.")

func load_previous_scene():
	if Global.current_scene_state:
		get_tree().current_scene.queue_free()
		var previous_scene_instance = Global.current_scene_state
		get_tree().root.add_child(previous_scene_instance)
		get_tree().current_scene = previous_scene_instance
		print("Poprzednia scena została załadowana.")
		Global.current_scene_state = null
	else:
		print("Brak zapisanej sceny do załadowania!")
	
	if Global.paused == true:
		Global.pause_menu.resume()
		
