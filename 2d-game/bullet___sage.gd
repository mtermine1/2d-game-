extends Area2D

@export var speed: float = 700.0
@export var damage_amount: int = 1  # each note does 1 damage (teacher has 1 health)

func _process(delta: float) -> void:
	position.x += speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):  # hit teacher
		if area.has_method("take_damage"):
			area.take_damage(damage_amount)
	queue_free()  # remove note after impactimpact


	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
