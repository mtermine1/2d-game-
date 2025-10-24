extends Area2D

@export var speed := 600.0         # how fast the note travels
@export var damage := 1            # damage it deals to enemies

# Called every frame
func _process(delta):
	position.x += speed * delta     # move horizontally

# Detect collision with enemies
func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)  # apply damage
		queue_free()                  # remove the note after impact

# Optional: if you also have an Area2D inside (like a hitbox)
func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()

# Clean up when it leaves the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
