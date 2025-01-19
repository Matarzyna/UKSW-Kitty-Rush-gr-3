extends Label

func _process(_delta):
	self.text = str(Global.gruby_cat_counter)
	
func reset_cat_count() -> void:
	Global.gruby_cat_counter = 0
	print("Fat kitty count reset to 0")
