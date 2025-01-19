extends Node2D

@export var damage: int = 1  # Liczba obrażeń zadawanych przez pułapkę
@export var animation_duration: float = 1.0  # Czas trwania animacji pułapki
@export var pause_duration: float = 2.0  # Czas pauzy przed kolejnym cyklem
@export var animation_start_delay: float = 1.0  # Opóźnienie przed rozpoczęciem animacji (tylko na starcie)
@export var spread_delay: float = 0.5  # Opóźnienie rozprzestrzeniania ognia między pułapkami

var is_active: bool = false  # Flaga aktywności pułapki
var connected_traps: Array = []  # Lista sąsiednich pułapek
var first_activation_done: bool = false  # Flaga wskazująca, czy pierwsze uruchomienie zostało wykonane

# Funkcja aktywująca pułapkę
func activate_trap():
	if not first_activation_done:  # Jeśli to pierwsze uruchomienie
		await get_tree().create_timer(animation_start_delay).timeout  # Poczekaj na opóźnienie przed animacją
		first_activation_done = true


	is_active = true
	$Area2D.monitoring = true  # Włącz kolizje, pułapka zadaje obrażenia
	$AnimatedSprite2D.animation = "default"  # Ustaw animację
	$AnimatedSprite2D.play()  # Rozpocznij odtwarzanie animacji
	await get_tree().create_timer(animation_duration).timeout  # Czekaj na czas trwania animacji
	deactivate_trap()  # Przełącz pułapkę w tryb pauzy

	# Aktywacja sąsiednich pułapek z opóźnieniem
	for trap in connected_traps:
		trap.call_deferred("spread_fire", spread_delay)

# Funkcja dezaktywująca pułapkę
func deactivate_trap():

	is_active = false
	$Area2D.monitoring = false  # Wyłącz kolizje, pułapka nie zadaje obrażeń
	$AnimatedSprite2D.stop()  # Zatrzymaj animację
	$AnimatedSprite2D.frame = 0  # Zresetuj animację do pierwszej klatki
	await get_tree().create_timer(pause_duration).timeout  # Czekaj na pauzę

	activate_trap()  # Uruchom cykl ponownie

# Funkcja aktywująca pułapkę na skutek rozsiewania ognia
func spread_fire(delay):
	await get_tree().create_timer(delay).timeout
	if not is_active:
		activate_trap()

# Funkcja wywoływana, gdy gracz wchodzi w obszar pułapki
func _on_Area2D_body_entered(body):
	if is_active and body.name == "Studentka":  # Sprawdź, czy obiekt to gracz
		body.take_damage(damage)  # Wywołaj funkcję zadawania obrażeń w skrypcie gracza

# Inicjalizacja
func _ready():
	$Area2D.monitoring = false  # Wyłącz kolizje na starcie
	$AnimatedSprite2D.frame = 0  # Ustaw pierwszą klatkę jako domyślną
	activate_trap()  # Rozpocznij działanie pułapki
