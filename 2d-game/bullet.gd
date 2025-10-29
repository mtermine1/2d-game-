extends Area2D

@export var speed := 600.0         # how fast the note travels
@export var damage := 1            # damage it deals to enemies

var velocity := Vector2.RIGHT * speed  # direction; adjust if shooting left/right

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
	position += velocity * delta

func _on_body_entered(body: Node2D):
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(damage)  # apply damage
		queue_free()              # remove the bullet/note after impact

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
