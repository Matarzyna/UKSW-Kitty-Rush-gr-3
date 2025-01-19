extends Area2D

var is_collected = false


func _ready() -> void:
	$AnimatedSprite2D.animation = "Gruby"  # Ustaw animację
	$AnimatedSprite2D.play() 
	
	if Global.gruby_cats_state.has(name):
		var state = Global.gruby_cats_state[name]
		set_state(state)
	else:
		print("Brak zapisanego stanu dla kotka:", name)

func _on_body_entered(_body: Node2D) -> void:
	if is_collected:
		return
	is_collected = true
	
	Global.gruby_cats_state += 1
	Global.gruby_cats_state[name] = {"is_collected": is_collected, "visible": false}
	$CollisionShape2D.call_deferred("set_disabled", true)
	call_deferred("set_visible", false)
	print(name, is_collected)

func set_state(state):
	is_collected = state.get("is_collected", false)
	visible = state.get("visible", true)
	$CollisionShape2D.disabled = is_collected
	set_visible(visible)
	print("Stan kotka ustawiony:", name, "is_collected:", is_collected, "visible:", visible)
