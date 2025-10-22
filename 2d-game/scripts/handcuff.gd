extends Area2D
class_name Handcuff

@export var speed := 420.0
@export var gravity := 900.0
@export var bind_seconds := 1.2

var velocity := Vector2.ZERO

func launch_towards(target_pos: Vector2):
    # Simple ballistic arc aimed roughly at target
    var dir = (target_pos - global_position).normalized()
    velocity = dir * speed
    velocity.y -= 300.0  # lift to create an arc

func _process(delta):
    velocity.y += gravity * delta
    position += velocity * delta
    if position.y > 2000 or position.x < -2000 or position.x > 4000:
        queue_free()

func _on_body_entered(body):
    if body and body.has_method("apply_bind"):
        body.apply_bind(bind_seconds)
    queue_free()
