extends Node

var player = null #referencja do gracza

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		print("Gracz odnaleziony: ", player)
	else:
		print("Nie znaleziono gracza w grupie 'player'!")

func force_death():
	if player != null:
		player.reset_to_checkpoint()
		print("Gracz został cofnięty do checkpointu:", player.death_position)
	else:
		print("Gracz nie został znaleziony!")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("force_death"):
		force_death()
