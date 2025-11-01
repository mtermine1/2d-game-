extends CharacterBody2D

# --- Bullet (optional; won’t crash if file missing) ---
const BULLET_PATH := "res://Bullet - Sage.tscn"
var Bullet: PackedScene = load(BULLET_PATH)

# --- Player stats ---
const SPEED := 300.0
const JUMP_VELOCITY := -800.0
@export var max_health := 3
var health := max_health
var health_bar
var camera_offset := 440

func _ready() -> void:
	if health_bar:
		health_bar.value = max_health

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	# Shoot (optional, only if Bullet exists and input mapped)
	if Input.is_action_just_pressed("attack") and Bullet:
		var newbullet = Bullet.instantiate()
		get_parent().add_child(newbullet)
		newbullet.global_position = global_position
	
	if shoot_sound:
		shoot_sound.pitch_scale = randf_range(0.9, 1.1)  # adds some variation
		shoot_sound.play()

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		# Python-style ternary in GDScript:
		camera_offset = 440 if direction == 1 else -440
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# --- Damage API (compatible with Matt’s enemies/projectiles) ---
func damage(amount: int) -> void:
	health -= amount
	prints("health:", health)
	if health < 0:
		health = 0

	if has_node("CanvasLayer/ProgressBar"):
		$CanvasLayer/ProgressBar.value = health

	# quick hit flash (optional)
	if has_node("Sprite"):
		$Sprite.modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(0.15).timeout
		$Sprite.modulate = Color(1, 1, 1)

	if health == 0:
		get_tree().reload_current_scene()
		
@onready var shoot_sound = $ShootSound
