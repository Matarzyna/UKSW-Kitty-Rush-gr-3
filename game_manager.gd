extends Node

var cats_score = 0
@onready var kitty_counter: Label = %kitty_counter

func add_cat_count() -> void:
	global.cats_score += 1
	print("Kitty count: ", global.cats_score)

	if kitty_counter != null:
		kitty_counter.text = "Kitty count: " + str(global.cats_score)
	else:
		print("kitty_counter is null! Check the node path.")
