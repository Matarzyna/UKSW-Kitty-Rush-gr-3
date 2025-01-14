extends Node

var player = null  # Referencja do gracza
var globalLife = 5
var life = 5

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		print("Gracz odnaleziony: ", player)
	else:
		print("Nie znaleziono gracza w grupie 'player'!")
	$CanvasLayer/Container/HBoxContainer3/AnimatedSprite2D.play("5")

func check_life(life: int):
	if life == 5:
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D5.play("default")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D4.play("default")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D3.play("default")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D2.play("default")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D.play("default")
	elif life == 4:
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D5.play("nothing")
	elif life == 3:
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D4.play("nothing")
	elif life == 2:
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D3.play("nothing")
	elif life == 1:
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D2.play("nothing")
	elif life == 0:
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D.play("nothing")

func force_death():
	if player != null:
		player.globalLife -= 1
		player.life = 5
		player.reset_to_checkpoint()  # Reset do punktu kontrolnego
		print("Gracz został cofnięty do checkpointu:", player.death_position)
		update_ui_life(player.life)
		reset_bushes()
	else:
		print("Gracz nie został znaleziony!")

func update_ui_life(life: int):
	if player != null:
		self.globalLife = player.globalLife
		$CanvasLayer/Container/HBoxContainer3/AnimatedSprite2D.play(str(self.globalLife))
		check_life(life)

func reset_bushes():
	var bushes = get_tree().get_nodes_in_group("bushes")
	for bush in bushes:
		if bush.has_method("reset_bush") and bush.is_destroy:
			bush.reset_bush()
			print("Zresetowano krzaczek: ", bush.name)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("force_death"):
		force_death()
		
func save_game_state():
	var save_data = {
		"globalLife": self.globalLife,
		"life": self.life
	}
	var file = FileAccess.open("res://saves/save_game.dat", FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()
		print("Stan gry zapisany!")
