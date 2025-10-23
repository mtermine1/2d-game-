extends CharacterBody2D

const Bullet = preload("res://Bullet - Sage.tscn")
const SPEED = 300.0
const JUMP_VELOCITY = -800.0

var camera_offset = 440

@export var max_health = 3
var health = max_health

func _ready() -> void:
	$CanvasLayer/ProgressBar.value = max_health

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("attack"):
		var newbullet = Bullet.instantiate()
		add_child(newbullet)

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

func damage(amount):
	health -= amount
	prints("health:", health)
	if health <= 0:
		health = 0
	$CanvasLayer/ProgressBar.value = health
	if health == 0:
		get_tree().reload_current_scene()
	#$AnimationPlayer.play("damage")
	
	
