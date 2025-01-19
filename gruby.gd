extends Area2D

var is_collected = false


func _ready() -> void:
	$AnimatedSprite2D.animation = "Gruby"  # Ustaw animację
	$AnimatedSprite2D.play() 
	
func _on_body_entered(_body: Node2D) -> void:
	if is_collected:
		return
	is_collected = true

	# Zwiększenie licznika grubych kotów
	Global.gruby_cat_counter += 1

	# Aktualizacja interfejsu użytkownika
	var game_manager = get_tree().get_nodes_in_group("GameManager")[0]
	if game_manager and game_manager.has_method("update_ui_gruby_cat_counter"):
		game_manager.update_ui_gruby_cat_counter(Global.gruby_cat_counter)
		print("Zaaktualizowano licznik grubych kotów w UI, na:", Global.gruby_cat_counter)
	else:
		print("Nie znaleziono GameManager lub brak metody update_ui_gruby_cat_counter")
	
	# Dezaktywacja obiektu
	$CollisionShape2D.call_deferred("set_disabled", true)
	call_deferred("set_visible", false)
	print(name, "Gruby kot zebrany. Aktualny licznik grubych kotów:", Global.gruby_cat_counter)

func set_state(state):
	is_collected = state.get("is_collected", false)
	visible = state.get("visible", true)
	$CollisionShape2D.disabled = is_collected
	set_visible(visible)
	print("Stan grubego kota ustawiony:", name, "is_collected:", is_collected, "visible:", visible)
