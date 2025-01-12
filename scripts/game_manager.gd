extends Node

var cats_score = 0
#@onready var kitty_counter: Label = %kitty_counter
@onready var kitty_counter = $"../CanvasLayerKC/kitty_counter" as Label

func add_cat_count() -> void:
	global.cats_score += 1
	print("Kitty count: ", global.cats_score)

	if kitty_counter != null:
		kitty_counter.text = "Kitty count: " + str(global.cats_score)
	else:
		print("kitty_counter is null! Check the node path.")

func reset_cat_count() -> void:
	global.cats_score = 0
	print("Kitty count reset to 0")
	
	if kitty_counter != null:
		kitty_counter.text = "Kitty count: 0"
	else:
		print("kitty_counter is null! Check the node path.")
