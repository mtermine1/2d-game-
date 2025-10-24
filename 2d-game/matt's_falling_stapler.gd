extends RigidBody2D

@export var fall_speed := 300.0  # base gravity multiplier
@export var destroy_below_y := 1000.0  # clean up when off-screen

func _ready():
	# Optional: apply a little random rotation or drift
	angular_velocity = randf_range(-2, 2)
	linear_velocity.x = randf_range(-50, 50)

func _process(delta):
	# Delete it when it falls off the bottom of the screen
	if global_position.y > destroy_below_y:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.damage(1)
	queue_free()
	pass # Replace with function body.
	
	
	
