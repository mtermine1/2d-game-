extends Area2D

@export var health := 1
@export var pencil_scene: PackedScene
@onready var throw_origin = $Marker2D
@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	add_to_group("enemy")  # ✅ So the player’s music notes recognize this as an enemy

func _on_timer_timeout():
	var pencil = pencil_scene.instantiate()
	get_parent().add_child(pencil)
	pencil.global_position = throw_origin.global_position
	pencil.speed = -300.0

# ✅ Called when hit by the player's projectile
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()  # remove teacher from scene

# ✅ This allows the music note (bullet) to call `take_damage` when it collides
func _on_body_entered(body):
	if body.is_in_group("player_projectile"):  # only reacts to player attacks
		if body.has_method("get_damage"):
			take_damage(body.get_damage())
		body.queue_free()  # remove the projectile
