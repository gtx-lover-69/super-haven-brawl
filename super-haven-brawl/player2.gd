extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player1 = $"../player1"
@onready var attack_area: Area2D = $AttackArea
@export var attack_damage := 10
@export var hit_time := 0.1

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var was_on_floor := false
var attacking := false

func _ready() -> void:
	attack_area.body_entered.connect(_on_attack_hit)
	sprite.animation_finished.connect(func(): attacking = false)
	add_collision_exception_with(player1)

func _shake(amount: float, decay := 40.0) -> void:
	var cam := get_tree().get_first_node_in_group("camera")
	if cam:
		cam.shake(amount, decay)
		
func _attack() -> void:
	attacking = true
	sprite.play("attack")
	await get_tree().create_timer(0.15).timeout
	_shake(10.0, 15.0)

	attack_area.set_deferred("monitoring", true)
	await get_tree().create_timer(hit_time).timeout
	attack_area.set_deferred("monitoring", false)
	
	if sprite.is_playing():
		await sprite.animation_finished
	attacking = false
	
func _on_attack_hit(body: Node2D) -> void:
	if body != self and body.has_method("take_damage"):
		body.take_damage(attack_damage)
		body.velocity.y = JUMP_VELOCITY 

func _physics_process(delta: float) -> void:
	attack_area.scale.x = -1 if sprite.flip_h else 1
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.1

	if Input.is_action_just_pressed("attack2") and is_on_floor() and not attacking:
		_attack()

	if Input.is_action_just_pressed("jump2") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left2", "right2")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 15)

	velocity.y = clampf(velocity.y, -850.0, 800.0)

	var impact := velocity.y
	move_and_slide()
	if is_on_floor() and not was_on_floor and impact > 300.0:
		_shake(impact / 100.0)
	was_on_floor = is_on_floor()

	if not attacking:
		if not is_on_floor():
			sprite.play("jump")
		elif direction:
			sprite.play("walk")
		else:
			sprite.play("idle")
