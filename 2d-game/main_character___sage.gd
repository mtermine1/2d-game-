extends AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -800.0

var camera_offset = 440


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction == 1:
			camera_offset=440
		else:
			camera_offset=-440
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if $Camera2D.position.x<=camera_offset:
		$Camera2D.position.x+=5
	else: 
		$Camera2D.position.x-=5
#what the heck is all this
