extends CharacterBody2D

@onready var raycast: RayCast2D = $RayCast2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var GRAVITY = 10
const SPEED = 65.0
const JUMP_VELOCITY = -400.0

var is_moving_left = false

func _physics_process(delta: float) -> void:
	detect_turn_around()
	velocity.x = -SPEED if is_moving_left else SPEED
	velocity.y += GRAVITY

	animated_sprite.play("walk")

	move_and_slide()

func detect_turn_around():
	if not raycast.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x

	if is_on_wall():
		is_moving_left = !is_moving_left
		scale.x = -scale.x
