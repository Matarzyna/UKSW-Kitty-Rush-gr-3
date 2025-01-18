#extends Control
#
## Deklaracja sygnału
#signal minigame_finished
#
#@onready var catch_bar: ProgressBar = $PanelContainer/MarginContainer/VBoxContainer/CatchBar
#@onready var kitty_to_catch: CharacterBody2D = $KittyToCatch
#@onready var target: Area2D = $Target
#@onready var message_label: Label = $messageLabel
#
## Zmienne
#var catching_value: float = 0.0
#var catch_speed: float = 0.3
#var is_catching: bool = false
#var is_game_finished: bool = false
#
#func _ready() -> void:
	## Ukryj wiadomość na starcie
	#message_label.visible = false
#
#func _physics_process(_delta: float) -> void:
	#if is_game_finished:
		#return
#
	## Aktualizowanie paska postępu
	#if is_catching:
		#catching_value += catch_speed
	#else:
		#catching_value -= catch_speed
#
	#catching_value = clamp(catching_value, 0.0, catch_bar.max_value)
	#catch_bar.value = catching_value
#
	## Sprawdź, czy pasek został zapełniony
	#if catching_value >= catch_bar.max_value:
		#_complete_game()
#
#func _complete_game() -> void:
	#print("Kotek złapany! Minigra zakończona.")
	#is_game_finished = true
#
	## Ukryj kota i cel
	#if is_instance_valid(kitty_to_catch):
		#kitty_to_catch.visible = false
	#if is_instance_valid(target):
		#target.visible = false
#
	## Wyświetl wiadomość
	#message_label.text = "You caught the kitty!"
	#message_label.visible = true
#
	## Wyemituj sygnał zakończenia
	#emit_signal("minigame_finished")
#
	## Timer do zamknięcia gry
	#var timer = Timer.new()
	#timer.wait_time = 3.0
	#timer.one_shot = true
	#add_child(timer)
	#timer.timeout.connect(_close_game)
	#timer.start()
#
#func _close_game() -> void:
	#print("Zamykanie minigry...")
	#queue_free()  # Usuń instancję minigry
#
#func _on_Target_body_entered(body: Node) -> void:
	#if body == kitty_to_catch:
		#is_catching = true
#
#func _on_Target_body_exited(body: Node) -> void:
	#if body == kitty_to_catch:
		#is_catching = false


extends Control
@onready var catch_bar: ProgressBar = %CatchBar
@onready var kitty_to_catch: CharacterBody2D = $"../KittyToCatch"

@onready var message_label: Label = $messageLabel
@onready var target: Area2D = $"../Target"

var onCatch := false
var catchSpeed := 0.3
var catchingValue := 0.0
var isCatchComplete := false  # Flaga oznaczająca zakończenie łapania
var is_game_active := false  # Czy gra jest aktywna

func _ready() -> void:

	# Ukryj kota na starcie
	if kitty_to_catch:
		kitty_to_catch.visible = false
	else:
		print("Error: KittyToCatch is not assigned or null.")
	
	
	# Wyświetl wiadomość "Złap kotka!" na początku
	message_label.text = "Catch the kitty!"
	message_label.visible = true

	# Uruchom timer, aby ukryć wiadomość po 2 sekundach
	var timer = Timer.new()
	timer.wait_time = 2.0  # Czas wyświetlania wiadomości w sekundach
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_hide_start_message)

func _hide_start_message() -> void:
	message_label.visible = false  # Ukryj wiadomość po 2 sekundach
	# Pokaż kota
	if kitty_to_catch:
		kitty_to_catch.visible = true
	else:
		print("Error: KittyToCatch is not assigned or null.")
	is_game_active = true  # Aktywuj grę	
		
func _physics_process(_delta: float) -> void:
	if not is_game_active or isCatchComplete:
		return
	
	if isCatchComplete:
		return  # Zatrzymujemy aktualizację, jeśli pasek osiągnął 100%

	# Aktualizuj wartość paska postępu
	if onCatch:
		catchingValue += catchSpeed
	else:
		catchingValue -= catchSpeed

	# Ogranicz wartość do zakresu 0 - maksymalna wartość paska
	catchingValue = clamp(catchingValue, 0.0, catch_bar.max_value)
	catch_bar.value = catchingValue

	# Sprawdź, czy pasek jest pełny
	if catchingValue >= catch_bar.max_value:
		_cat_caught()

func _cat_caught() -> void:
	# Wywołanie po złapaniu kota
	print("Kotek złapany!")
	isCatchComplete = true  # Ustaw flagę, aby zatrzymać aktualizację paska
	if kitty_to_catch:
		kitty_to_catch.visible = false  # Ukryj kota
	else:
		print("Error: KittyToCatch is not assigned or null.")
	# Ukryj target
	if target:
		target.visible = false
	else:
		print("Error: Target is not assigned or null.")

		
	# Wyświetl wiadomość
	message_label.text = "You caught the kitty!"
	message_label.visible = true

	# Uruchom timer do zamknięcia gry
	var timer = Timer.new()
	timer.wait_time = 3.0  # Czas w sekundach do zamknięcia gry
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_close_game)

func _close_game() -> void:
	print("Zamykanie gry...")
	# Usuń target, jeśli istnieje
	if target and is_instance_valid(target):
		target.queue_free()
	queue_free() 

func _on_target_target_entered() -> void:
	# Zdarzenie: kot został złapany
	onCatch = true

func _on_target_target_exited() -> void:
	# Zdarzenie: kot uciekł
	onCatch = false
