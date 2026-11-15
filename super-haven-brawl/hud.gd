extends CanvasLayer

@onready var bar1: ProgressBar = $health1
@onready var bar2: ProgressBar = $health2
@onready var player1 = $"../player1"
@onready var player2 = $"../player2"

func _ready() -> void:
	player1.health_changed.connect(_update.bind(bar1))
	player2.health_changed.connect(_update.bind(bar2))
	_update(player1.health, player1.MAX_HEALTH, bar1)
	_update(player2.health, player2.MAX_HEALTH, bar2)

func _update(current: int, maximum: int, bar: ProgressBar) -> void:
	bar.max_value = maximum
	bar.value = current
