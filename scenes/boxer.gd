extends CharacterBody2D

@onready var raycast: RayCast2D = $RayCast2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var isCyborg = false


@export var attackDamage = 33

var GRAVITY = 10
const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var is_moving_left = false

var is_hitting = false
var player_in_detector = false
var player_in_attack_area = false
var player = null

func _ready() -> void:
	animated_sprite.play("walk")

func _physics_process(delta: float) -> void:
	velocity.x = -SPEED if is_moving_left else SPEED
	velocity.y += GRAVITY
	
	if is_hitting:
		velocity.x = 0

	move_and_slide()
	# is_on_wall MUST be called after move_and_slide
	detect_turn_around()

func detect_turn_around():
	if not raycast.is_colliding() and is_on_floor() or is_on_wall():
		is_moving_left = !is_moving_left
		scale.x = -scale.x

func _on_player_detector_body_entered(body: Node2D) -> void:
	is_hitting = true
	player_in_detector = true
	animated_sprite.play("punch")
	$AttackArea.monitoring = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	player_in_detector = false


func _on_animated_sprite_2d_animation_looped() -> void:
	if is_hitting:
		if player_in_attack_area:
			player.hit(attackDamage)
		else:
			animated_sprite.play("walk")
			is_hitting = false
		
			$AttackArea.monitoring = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	player_in_attack_area = true
	player = body


func _on_attack_area_body_exited(body: Node2D) -> void:
	player_in_attack_area = false
