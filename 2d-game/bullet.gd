extends AnimatedSprite2D
@export var speed = 2.0
@export var damage_amount = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed
	animation


func _on_area_2d_body_entered(body):
	body.damage(damage_amount)
	queue_free()
	
func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.queue_free()    # remove the teache
		queue_free()         # remove the bullet

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
