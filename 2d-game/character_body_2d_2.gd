extends CharacterBody2D

const SPEED = 100.0
const CHANGE_DIR_INTERVAL = 2.0
const PAUSE_CHANCE = 0.3

var direction = Vector2.ZERO
var time_since_change = 0.0
var rng = RandomNumberGenerator.new()
var bg_left = 0.0
var bg_right = 0.0
var bg_top = 0.0
var bg_bottom = 0.0

func _ready():
	rng.randomize()
	_pick_new_direction()
	_set_background_limits()

func _physics_process(delta):
	time_since_change += delta

	# Move or stay still
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		move_and_slide()
	else:
		velocity = Vector2.ZERO

	# Change direction every few seconds
	if time_since_change > CHANGE_DIR_INTERVAL:
		_pick_new_direction()
		time_since_change = 0.0

	# Clamp NPC position to background bounds
	global_position.x = clamp(global_position.x, bg_left, bg_right)
	global_position.y = clamp(global_position.y, bg_top, bg_bottom)

func _pick_new_direction():
	if rng.randf() < PAUSE_CHANCE:
		direction = Vector2.ZERO
	else:
		direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()

func _set_background_limits():
	var bg = get_parent().get_node("Background")  # adjust if the path differs
	if bg and bg is Sprite2D:
		var tex_size = bg.texture.get_size() * bg.scale
		var bg_pos = bg.global_position
		bg_left = bg_pos.x - tex_size.x / 2
		bg_right = bg_pos.x + tex_size.x / 2
		bg_top = bg_pos.y - tex_size.y / 2
		bg_bottom = bg_pos.y + tex_size.y / 2
