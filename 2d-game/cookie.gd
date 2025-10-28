extends CharacterBody2D
var speed = 400
var direction = Vector2.LEFT

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
