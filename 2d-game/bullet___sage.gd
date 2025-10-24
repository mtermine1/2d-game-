extends Area2D

@export var speed: float = 700.0
@export var damage_amount: int = 1  # each note does 1 damage (teacher has 1 health)

# To prevent double collisions (common in Godot)
var has_hit := false

func _process(delta: float) -> void:
	position.x += speed * delta

func _on_area_entered(area: Area2D) -> void:
	if has_hit:
		return  # ✅ skip if this bullet already hit something

	if area.is_in_group("enemy"):  # ✅ only hits enemies
		if area.has_method("take_damage"):
			area.take_damage(damage_amount)
		has_hit = true
		queue_free()  # remove note after impact
