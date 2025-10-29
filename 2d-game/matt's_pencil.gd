extends Area2D

@export var speed := 900.0
@export var fall_gravity := 600.0
@export var damage_amount := 1

var velocity := Vector2.ZERO

func _ready():
	add_to_group("enemy_projectile")  # so player can identify it if needed
	velocity = Vector2(-speed, 0)  # flies left by default (teachers face left)

func _process(delta):
	# Apply gravity for downward arc
	velocity.y += gravity * delta
	position += velocity * delta

# ✅ When the pencil hits the player
func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("damage"):
			body.damage(damage_amount)
		queue_free()

# ✅ When it hits the floor or goes offscreen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
