extends Node

const SAVE_FILE_PATH = "user://save_game.dat"

func save_game():
	# Zapisywanie stanów krzaków
	var bushes = get_tree().get_nodes_in_group("bushes")
	Global.bushes_state.clear()
	for bush in bushes:
		Global.bushes_state[bush.name] = {
			"is_destroyed": bush.is_destroy,
			"visible": bush.visible
		}
	print("Stany krzaków zapisane")

	# Zapisywanie stanów kotków
	var cats = get_tree().get_nodes_in_group("cats")
	Global.cats_state.clear()
	for cat in cats:
		Global.cats_state[cat.name] = {
			"is_collected": cat.is_collected,
			"visible": cat.visible
		}
	print("Stany kotków zapisane", Global.cats_state)

	# Zapis danych do pliku
	var save_data = {
		"bushes_state": Global.bushes_state,
		"cats_state": Global.cats_state,
		"player_position": Global.death_position,
		"GlobalLife": Global.globalLife,
		"life": Global.life,
		"cat_counter": Global.cat_counter
	}
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()
		print("Gra zapisana")

# Funkcja wczytywania gry
func load_game():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	if file:
		var save_data = file.get_var()
		file.close()
		
		# Wczytaj stany krzaków i kotków do Global
		Global.bushes_state = save_data.get("bushes_state", {})
		print("Stany krzaków załadowane")
		Global.cats_state = save_data.get("cats_state", {})
		print("Stany kotów załadowane", Global.cats_state)

		# Wczytaj inne dane globalne
		Global.death_position = save_data.get("player_position", Vector2(0, 0))
		Global.globalLife = save_data.get("GlobalLife", 5)
		Global.life = save_data.get("life", 5)
		Global.cat_counter = save_data.get("cat_counter", 0)
		print("Gra wczytana!")
