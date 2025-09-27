extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $killzone
@onready var goomba: CharacterBody2D = $"."

var GRAVITY = 10
const SPEED = 65.0
const JUMP_VELOCITY = -400.0

var is_moving_left = true


func _physics_process(delta: float) -> void:
	detect_turn_around()
	velocity.x = -SPEED if is_moving_left else SPEED
	velocity.y += GRAVITY
	
	# Animation
	animated_sprite.play("walk")

	move_and_slide()

func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x
		print("Time to turn around")


func _on_killzone_body_entered(body: Node2D) -> void:
	goomba.queue_free()
