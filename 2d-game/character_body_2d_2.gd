extends CharacterBody2D

@export var speed := 400.0
@export var damage := 1
var direction := Vector2.ZERO

@export var max_health := 10
@export var cookie_scene: PackedScene   # drag cookie.tscn into this in Inspector
@export var shoot_interval := 2.0       # seconds between shots
@export var cookie_speed := 400.0

var health := max_health
signal grandma_died

@onready var player := get_tree().get_first_node_in_group("player")
@onready var shoot_timer := $ShootTimer

func _ready():
	# Ensure Grandma is in the "enemy" group so player bullets can hit her
	add_to_group("enemy")

	# Connect collisions
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	# Start shooting timer
	if shoot_timer:
		shoot_timer.wait_time = shoot_interval
		shoot_timer.start()
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	# Hit player only
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
	elif body.is_in_group("solid"):
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_shoot_timer_timeout():
	if not player or health <= 0:
		return
	shoot_cookie()

func shoot_cookie():
	if not cookie_scene:
		print("⚠️ No cookie scene assigned!")
		return

	if not player:
		return

	# Calculate direction to player
	var dir = (player.global_position - global_position).normalized()

	# Instantiate cookie and pass shooter (self)
	var cookie = cookie_scene.instantiate()
	cookie.setup(dir, cookie_speed, self)
	get_tree().current_scene.add_child(cookie)

	# Spawn cookie slightly in front of Grandma to avoid initial overlap
	cookie.global_position = global_position + dir * 60

	# Flip Grandma sprite to face player
	if has_node("Sprite2D"):
		$Sprite2D.flip_h = dir.x < 0


func take_damage(amount: int):
	if health <= 0:
		return
	health -= amount
	print("Grandma took", amount, "damage. HP:", health)

	# Optional: flash red briefly when hit
	if has_node("Sprite2D"):
		$Sprite2D.modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(0.1).timeout
		$Sprite2D.modulate = Color(1, 1, 1)

	if health <= 0:
		die()

func die():
	print("💀 Grandma is dead!")
	emit_signal("grandma_died")
	if $ShootTimer:
		$ShootTimer.stop()
	queue_free()
