extends CharacterBody2D

const Bullet = preload("res://Bullet - Sage.tscn")
const SPEED = 350.0
const JUMP_VELOCITY = -800.0

var camera_offset = 440

@export var max_health = 3
var health = max_health

@export var fire_rate := 0.4  # seconds between shots
var can_fire := true

@onready var fire_timer: Timer = $FireRateTimer
@onready var health_bar = $CanvasLayer/ProgressBar   # ✅ Link to your on-screen bar

func _ready() -> void:
	# ✅ Connect fire rate timer
	fire_timer.timeout.connect(_on_fire_rate_timeout)
	
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

	# ✅ Attack (shoot music note) with cooldown
	if Input.is_action_just_pressed("attack") and can_fire:
		shoot_bullet()
		can_fire = false
		fire_timer.start(fire_rate)

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


# ✅ Fire function
func shoot_bullet() -> void:
	var new_bullet = Bullet.instantiate()
	get_parent().add_child(new_bullet)
	new_bullet.global_position = global_position


# ✅ Fire timer callback
func _on_fire_rate_timeout() -> void:
	can_fire = true


# ✅ Damage function
func damage(amount: int) -> void:
	health -= amount
	health = clamp(health, 0, max_health)
	print("Health:", health)

	if health_bar:
		if health_bar.max_value != max_health:
			health_bar.value = float(health) / float(max_health) * health_bar.max_value
		else:
			health_bar.value = health

	if health <= 0:
		print("Player died! Restarting level...")
		get_tree().reload_current_scene()


func _on_grandma_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
