extends AnimatedSprite2D

@export var speed: float = 600.0
@export var damage_amount: int = 1  # each note does 1 damage (teacher has 1 health)

func _process(delta: float) -> void:
	position.x += speed * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):  # ✅ only hit teachers
		if body.has_method("take_damage"):
			body.take_damage(damage_amount)
		queue_free()  # remove the note after impact

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
