extends Control

@onready var catch_bar: ProgressBar = %CatchBar
@onready var kitty_to_catch: CharacterBody2D = $"../KittyToCatch"
@onready var message_label: Label = $messageLabel

var onCatch := false
var catchSpeed := 0.3
var catchingValue := 0.0
var isCatchComplete := false  # Flaga oznaczająca zakończenie łapania

func _ready() -> void:
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

func _physics_process(_delta: float) -> void:
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
	get_tree().quit()  # Zamyka aplikację

func _on_target_target_entered() -> void:
	# Zdarzenie: kot został złapany
	onCatch = true

func _on_target_target_exited() -> void:
	# Zdarzenie: kot uciekł
	onCatch = false
