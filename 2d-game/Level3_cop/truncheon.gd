extends RigidBody2D

# despawn after a timeout to avoid clutter
@export var lifetime: float = 5.0

func _ready():
	# ensure it falls naturally; I can tweak gravity_scale in Inspector
	_auto_despawn()

func _auto_despawn() -> void:
	# non-blocking: schedule free after lifetime seconds
	var t = get_tree().create_timer(lifetime)
	t.timeout.connect(self.queue_free)

# reaction for physics body collisions
func _on_truncheon_body_entered(body: Node) -> void:
	# only damage player objects placed in group "player"
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		else:
			print("Warning: body has no take_damage method")
		queue_free()
