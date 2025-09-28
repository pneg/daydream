extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@export var maxHealth = 100.0
@onready var currentHealth: float = maxHealth

signal healthChanged

const SPEED = 400.0
const JUMP_VELOCITY = -900.0
const MAIN_SCENE_PATH = "res://scenes/main.tscn"

# Shooting
@export var bullet_scene: PackedScene
@export var shootHealthCost: float = 10.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 60)
  
	# Animation
	if direction < 0:
		animated_sprite.play("walk_left")
	elif direction > 0:
		animated_sprite.play("walk_right")
	else:
		animated_sprite.stop()

	move_and_slide()

	var screen_bottom := get_viewport_rect().size.y
	if global_position.y > screen_bottom + 500:
		respawn_world()

	# Shooting input
	if Input.is_action_just_pressed("shoot"):
		shoot()

func hit(damage: int):
	currentHealth -= damage
	healthChanged.emit()

	if currentHealth <= 0:
		respawn_world()

func respawn_world():
	call_deferred("_do_respawn")

func _do_respawn():
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)

func shoot():
	if currentHealth > shootHealthCost:
		currentHealth -= shootHealthCost
		healthChanged.emit()

		var bullet = bullet_scene.instantiate()
		var offset = Vector2(0, -40)

		if animated_sprite.animation == "walk_left":
			bullet.direction = Vector2.LEFT
			bullet.position = global_position + offset
			bullet.rotation = PI
		else:
			bullet.direction = Vector2.RIGHT
			bullet.position = global_position + offset
			bullet.rotation = 0

		get_parent().add_child(bullet)
	else:
		print("Not enough health to shoot!")
