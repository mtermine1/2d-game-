extends AnimatedSprite2D

@export var speed: float = 600.0
@export var damage_amount: int = 5

func _process(delta: float) -> void:
	position.x += speed * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("damage"):
		body.damage(damage_amount)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
