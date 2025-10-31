extends Area2D

@export var speed := 400.0
@export var damage_amount := 1
var direction := Vector2.ZERO
var shooter = null  # reference to Grandma

# ✅ This function is called by Grandma to set up cookie direction
func setup(dir: Vector2, cookie_speed: float, origin: Node) -> void:
	direction = dir
	speed = cookie_speed
	shooter = origin

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("damage"):
			body.damage(damage_amount)
		queue_free()

# ✅ If it goes offscreen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
