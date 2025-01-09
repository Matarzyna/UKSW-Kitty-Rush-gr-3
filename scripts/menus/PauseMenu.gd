extends Node

var is_game_over = false

func _ready():
	$PauseMenu.visible = false
	$PauseMenu/VBoxContainer.set_pause_canvas(self)

func resume():
	get_tree().paused = false
	$PauseMenu.visible = false

func pause():
	get_tree().paused = true
	$PauseMenu.visible = true

func testESC():
	if not is_game_over:
		if Input.is_action_just_pressed("pause") and get_tree().paused == false:
			pause()
		elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
			resume()

func _process(_delta):
	testESC()
