extends Node

const SAVE_FILE_PATH = "user://save_game.dat"

func save_game():
	save_state()
	# Zapis danych do pliku
	var save_data = {
		"bushes_state": Global.bushes_state,
		"cats_state": Global.cats_state,
		"chests_state": Global.chests_state,
		"player_position": Global.death_position,
		"GlobalLife": Global.globalLife,
		"life": Global.life,
		"cat_counter": Global.cat_counter,
		"gruby_cat_counter": Global.gruby_cat_counter
	}
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()
		print("Gra zapisana")

# Funkcja wczytywania gry
func load_game():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("Brak pliku zapisu, gra nie została wczytana")
		return

	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file:
		var save_data = file.get_var()
		file.close()
		
		# Wczytaj stany krzaków i kotków do Global
		Global.bushes_state = save_data.get("bushes_state", {})
		print("Stany krzaków załadowane")
		Global.cats_state = save_data.get("cats_state", {})
		print("Stany kotków załadowane")
		Global.chests_state = save_data.get("chests_state", {})
		print("Stany skrzynek załadowane")

		# Wczytaj inne dane globalne
		Global.death_position = save_data.get("player_position", Vector2(0, 0))
		Global.globalLife = save_data.get("GlobalLife", 5)
		Global.life = save_data.get("life", 5)
		Global.cat_counter = save_data.get("cat_counter", 0)
		Global.gruby_cat_counter = save_data.get("gruby_cat_counter", 0)
		print("Gra wczytana!")

func save_state():
	# Zapisywanie stanów krzaków
	var bushes = get_tree().get_nodes_in_group("bushes")
	Global.bushes_state.clear()
	for bush in bushes:
		if "is_destroy" in bush and "visible" in bush:
			Global.bushes_state[bush.name] = {
				"is_destroyed": bush.is_destroy,
				"visible": bush.visible
			}
	print("Stany krzaków zapisane")

	# Zapisywanie stanów kotków
	var cats = get_tree().get_nodes_in_group("cats")
	Global.cats_state.clear()
	for cat in cats:
		if "is_collected" in cat and "visible" in cat:
			Global.cats_state[cat.name] = {
				"is_collected": cat.is_collected,
				"visible": cat.visible
			}
	print("Stany kotków zapisane")

	# Zapisywanie stanów grubych kotków
	var Fatcats = get_tree().get_nodes_in_group("FatCats")
	Global.gruby_cats_state.clear()
	for F in Fatcats:
		if "is_collected" in F and "visible" in F:
			Global.gruby_cats_state[F.name] = {
				"is_collected": F.is_collected,
				"visible": F.visible
			}
	print("Stany grubych kotków zapisane")
	
	# Zapisywanie stanów skrzynek
	var chests = get_tree().get_nodes_in_group("chests")
	Global.chests_state.clear()
	for chest in chests:
		if "is_opened" in chest:
			Global.chests_state[chest.name] = {
				"is_opened": chest.is_opened
			}
	print("Stany skrzynek zapisane")
