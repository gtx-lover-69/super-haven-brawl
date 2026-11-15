extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.velocity.y > 0:
		body.velocity.y = -body.velocity.y * 1.2
		get_tree().get_first_node_in_group("camera").shake(body.velocity.y / 60.0)
