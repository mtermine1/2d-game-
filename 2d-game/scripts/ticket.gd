extends Area2D
class_name Ticket

@export var speed := 140.0
@export var bob_amplitude := 8.0
@export var bob_speed := 4.0

var base_y := 0.0
var t := 0.0

func _ready():
    base_y = position.y
    add_to_group("cop_level_ticket")
    $VisibleOnScreenNotifier2D.connect("screen_exited", Callable(self, "_on_screen_exited"))

func _process(delta):
    t += delta
    position.x -= speed * delta
    position.y = base_y + sin(t * bob_speed) * bob_amplitude

func _on_screen_exited():
    queue_free()

func _on_body_entered(body):
    # If hit by player's music note (ensure your projectile is in this group)
    if body.is_in_group("projectile_music"):
        queue_free()
