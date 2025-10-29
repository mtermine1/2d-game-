extends Area2D

@export var speed := 600.0
@export var gravity_force := 0.0  # straight-line shooting
@export var lifetime := 5.0        # cookie will disappear after 5 seconds

var velocity := Vector2.ZERO
var direction := Vector2.ZERO
var timer := 0.0

# Track the shooter to ignore collisions
var shooter: Node = null

func setup(dir: Vector2, spd: float, shooter_node: Node):
	direction = dir.normalized()
	speed = spd
	velocity = direction * speed
	shooter = shooter_node

func _ready():
	if has_node("CollisionShape2D"):
		var shape = $CollisionShape2D
		# Optional: brief delay so it doesn't collide immediately with Grandma
		shape.disabled = true
		await get_tree().create_timer(0.1).timeout
		shape.disabled = false

func _process(delta):
	velocity.y += gravity_force * delta
	position += velocity * delta

	timer += delta
	if timer > lifetime:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body == shooter:
		return  # ignore Grandma
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(1)
	queue_free()
