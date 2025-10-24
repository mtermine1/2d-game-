extends CharacterBody2D

const Bullet = preload("res://Bullet - Sage.tscn")
const SPEED = 300.0
const JUMP_VELOCITY = -800.0

var camera_offset = 440

@export var max_health = 3
var health = max_health

@onready var health_bar = $CanvasLayer/ProgressBar   # ✅ Link to your on-screen bar

func _ready() -> void:
	# ✅ Make sure health bar starts full
	health = max_health
	if health_bar:
		health_bar.value = health_bar.max_value if health_bar.has_method("max_value") else max_health
		health_bar.value = max_health
		print("Health bar initialized:", health)

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Attack (shoot music note)
	if Input.is_action_just_pressed("attack"):
		var new_bullet = Bullet.instantiate()
		get_parent().add_child(new_bullet)
		new_bullet.global_position = global_position

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Move left/right
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		camera_offset = 440 if direction == 1 else -440
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func damage(amount: int) -> void:
	# ✅ Subtract health and update UI
	health -= amount
	health = clamp(health, 0, max_health)
	print("Health:", health)

	if health_bar:
		# ✅ Convert to percentage if ProgressBar max_value != max_health
		if health_bar.max_value != max_health:
			health_bar.value = float(health) / float(max_health) * health_bar.max_value
		else:
			health_bar.value = health

	# ✅ Handle death / reset
	if health <= 0:
		print("Player died! Restarting level...")
		get_tree().reload_current_scene()
