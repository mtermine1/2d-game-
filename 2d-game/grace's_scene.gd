extends CharacterBody2D

@export var speed: float = 600.0
@export var gravity_force: float = 600.0
@export var throw_angle_degrees: float = -20.0  # negative = slightly upward

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	var angle = deg_to_rad(throw_angle_degrees)
	velocity = Vector2(-speed * cos(angle), speed * sin(angle))

func _physics_process(delta: float) -> void:
	velocity.y += gravity_force * delta
	position += velocity * delta

	if position.x < -100 or position.x > 4000:
		queue_free()

# If you connect an Area2D's "area_entered" signal to this method:
func _on_area_entered(area: Node) -> void:
	if area is Node2D and area.is_in_group("player"):
		area.call_deferred("damage", 1)  # call_deferred in case the player does something during the signal
	queue_free()
