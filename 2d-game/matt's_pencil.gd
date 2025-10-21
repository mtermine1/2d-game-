extends Area2D

@export var speed := 600.0
@export var gravity_force := 600.0
@export var throw_angle_degrees := -20.0  # negative = slightly upward
@onready var velocity = Vector2.ZERO

func _ready():
	var angle = deg_to_rad(throw_angle_degrees)
	velocity = Vector2(-speed * cos(angle), speed * sin(angle))

func _process(delta):
	velocity.y += gravity_force * delta   # renamed variable here
	position += velocity * delta

	if position.x < -100 or position.x > 4000:
		queue_free()
