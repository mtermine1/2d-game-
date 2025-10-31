extends Area2D

@export var health := 5
@export var damage := 1
@export var cookie_scene: PackedScene
@export var shoot_interval := 2.0
@export var cookie_speed := 300.0

@onready var shoot_timer := $ShootTimer
@onready var player := get_tree().get_first_node_in_group("player")

func _ready():
	add_to_group("enemy")  # So bullets recognize her as an enemy

	if shoot_timer:
		shoot_timer.wait_time = shoot_interval
		shoot_timer.start()
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)

#Damage handling
func take_damage(amount: int):
	health -= amount
	print("Grandma took", amount, "damage. HP:", health)
	if health <= 0:
		die()


func die():
	print("💀 Grandma defeated!")
	queue_free()


#Auto-fire cookies toward the player
func _on_shoot_timer_timeout():
	if not player:
		return
	shoot_cookie()


func shoot_cookie():
	if not cookie_scene:
		print("⚠️ No cookie scene assigned!")
		return

	#instantiate the actual cookie scene
	var cookie = cookie_scene.instantiate()
	get_tree().current_scene.add_child(cookie)
	cookie.global_position = global_position

	#calculate direction to player
	var dir = (player.global_position - global_position).normalized()

	# ✅ tell the cookie where to go
	if "direction" in cookie:
		cookie.direction = dir
	elif "setup" in cookie:
		cookie.setup(dir, cookie_speed, self)
	elif "velocity" in cookie:
		cookie.velocity = dir * cookie_speed

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectiles"):
		if "damage_amount" in area:
			take_damage(area.damage_amount)
		else:
			take_damage(1)
		area.queue_free()
