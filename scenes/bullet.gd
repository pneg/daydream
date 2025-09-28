extends RigidBody2D

@export var speed: float = 1000.0
var direction: Vector2 = Vector2.RIGHT

func _ready():
	add_to_group("bullets")
	gravity_scale = 0.1
	linear_velocity = direction * speed

func _process(delta: float):
	position += direction * speed * delta
