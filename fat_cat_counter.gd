extends CanvasLayer


func _ready() -> void:
	$AnimatedSprite2D.animation = "Gruby"  # Ustaw animację
	$AnimatedSprite2D.play() 
	
