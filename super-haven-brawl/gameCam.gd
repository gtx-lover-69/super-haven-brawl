extends Camera2D

@export var max_shake := 20.0
@export var default_decay := 40.0

var strength := 0.0
var decay := 40.0

func _ready() -> void:
	add_to_group("camera")

func shake(amount: float, new_decay: float = default_decay) -> void:
	if amount >= strength:
		strength = minf(amount, max_shake)
		decay = new_decay

func _process(delta: float) -> void:
	strength = move_toward(strength, 0.0, decay * delta)
	offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * strength
