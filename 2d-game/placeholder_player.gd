extends CharacterBody2D


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
# Move the player

# Smooth camera follow with slight lag and directional offset
var target_offset_x = 440 if velocity.x > 0 else -440 if velocity.x < 0 else $Camera2D.offset.x
$Camera2D.offset.x = lerp($Camera2D.offset.x, target_offset_x, 0.05)

# Smooth position lag behind the player
var target_camera_pos = global_position
$Camera2D.global_position.x = lerp($Camera2D.global_position.x, target_camera_pos.x, 0.1)
$Camera2D.global_position.y = lerp($Camera2D.global_position.y, target_camera_pos.y, 0.1)
