extends Label

func _process(_delta):
	self.text = str(Global.cat_counter)
	
func reset_cat_count() -> void:
	Global.cat_counter = 0
	print("Kitty count reset to 0")
