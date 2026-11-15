extends Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	sprite.play("default")

func _on_body_entered(body):
	sprite.play("squished")
	await sprite.animation_finished
	sprite.play("default")
