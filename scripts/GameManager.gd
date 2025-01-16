extends Node

var player = null  # Referencja do gracza

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		print("Gracz odnaleziony: ", player)
		player.reset_to_checkpoint()
	else:
		print("Nie znaleziono gracza w grupie 'player'!")
	$CanvasLayer/Container/HBoxContainer3/AnimatedSprite2D.play(str(Global.globalLife))
	check_life(Global.life)

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
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D5.play("nothing")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D4.play("nothing")
	elif life == 2:
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D5.play("nothing")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D4.play("nothing")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D3.play("nothing")
	elif life == 1:
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D5.play("nothing")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D4.play("nothing")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D3.play("nothing")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D2.play("nothing")
		
	elif life == 0:
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D5.play("nothing")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D4.play("nothing")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D3.play("nothing")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D2.play("nothing")
		$CanvasLayer/Container/HBoxContainer2/AnimatedSprite2D.play("nothing")
		
func show_game_over_screen():
	$CanvasLayer.visible = false
	$CanvasLayerKC.visible = false
	$GameOverCanvas.visible = true
	get_tree().paused = true
	
	var pause_menu = get_node("/root/Levels/PauseCanvas")
	if pause_menu:
		pause_menu.is_game_over = true
	else:
		print("PauseCanvas not found")
		
	Global.reset_game()
	SaveManager.save_game()

func force_death():
	if player != null:
		Global.globalLife -= 1
		Global.life = 5
		if Global.globalLife <= 0:
			update_ui_life(Global.life)
			show_game_over_screen()
		else:
			player.reset_to_checkpoint()  # Reset do punktu kontrolnego
			print("Gracz został cofnięty do checkpointu:", Global.death_position)
			update_ui_life(Global.life)
			reset_bushes()
	else:
		print("Gracz nie został znaleziony!")

func update_ui_life(life: int):
	if player != null:
		var globalLife = Global.globalLife
		$CanvasLayer/Container/HBoxContainer3/AnimatedSprite2D.play(str(Global.globalLife))
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
