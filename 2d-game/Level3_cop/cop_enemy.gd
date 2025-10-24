extends CharacterBody2D

const TRUNCHEON_SCENE := preload("res://Level3_cop/truncheon.tscn")


@export var speed := 100.0
@export var patrol_distance := 300.0
@export var throw_rate := 2.0 # seconds between throws

var start_x
var direction := 1
var throw_timer := 0.0

func _ready():
	start_x = global_position.x

func _physics_process(delta):
	# Patrol left-right
	global_position.x += speed * direction * delta
	if abs(global_position.x - start_x) > patrol_distance:
		direction *= -1
		$Sprite.flip_h = direction < 0

	# Timer for next throw
	throw_timer -= delta
	if throw_timer <= 0:
		throw_truncheon()
		throw_timer = throw_rate

func throw_truncheon():
	var t = TRUNCHEON_SCENE.instantiate()
	get_parent().add_child(t)
	t.global_position = global_position + Vector2(0, -10)  # slightly above cop
	t.linear_velocity = Vector2(-200, 0)  # move leftwards
