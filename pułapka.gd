extends Node2D

@export var damage: int = 1  # Liczba obrażeń zadawanych przez pułapkę
@export var animation_duration: float = 1.0  # Czas trwania animacji pułapki
@export var pause_duration: float = 1.0  # Czas pauzy przed kolejnym cyklem

var is_active: bool = false  # Flaga aktywności pułapki

# Funkcja aktywująca pułapkę
func activate_trap():
	print("Pułapka aktywowana")
	is_active = true
	$Area2D.monitoring = true  # Włącz kolizje, pułapka zadaje obrażenia
	$AnimatedSprite2D.animation = "default"  # Ustaw animację
	$AnimatedSprite2D.play()  # Rozpocznij odtwarzanie animacji
	await get_tree().create_timer(animation_duration).timeout  # Czekaj na czas trwania animacji
	deactivate_trap()  # Przełącz pułapkę w tryb pauzy

# Funkcja dezaktywująca pułapkę
func deactivate_trap():
	print("Pułapka dezaktywowana")
	is_active = false
	$Area2D.monitoring = false  # Wyłącz kolizje, pułapka nie zadaje obrażeń
	$AnimatedSprite2D.stop()  # Zatrzymaj animację
	$AnimatedSprite2D.frame = 0  # Zresetuj animację do pierwszej klatki
	await get_tree().create_timer(pause_duration).timeout  # Czekaj na pauzę
	print("Pułapka gotowa do ponownej aktywacji")
	activate_trap()  # Uruchom cykl ponownie

# Funkcja wywoływana, gdy gracz wchodzi w obszar pułapki
func _on_Area2D_body_entered(body):
	if is_active and body.name == "Studentka":  # Sprawdź, czy obiekt to gracz
		body.take_damage(damage)  # Wywołaj funkcję zadawania obrażeń w skrypcie gracza
		print("Gracz otrzymał obrażenia:", damage)

# Inicjalizacja
func _ready():
	$Area2D.monitoring = false  # Wyłącz kolizje na starcie
	$AnimatedSprite2D.frame = 0  # Ustaw pierwszą klatkę jako domyślną
	activate_trap()  # Rozpocznij działanie pułapki
