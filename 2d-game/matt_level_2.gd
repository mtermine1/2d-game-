extends Node2D

@export var falling_obstacle_scene: PackedScene
@export var spawn_interval := 2.0  # seconds between drops
@export var spawn_x_range := Vector2(0, 2000)  # area across top of level

var timer := 0.0

func _process(delta):
	timer += delta
	if timer >= spawn_interval:
		timer = 0
		spawn_falling_obstacle()

func spawn_falling_obstacle():
	var obstacle = falling_obstacle_scene.instantiate()
	add_child(obstacle)
	obstacle.global_position = Vector2(
		randf_range(spawn_x_range.x, spawn_x_range.y),
		-400  # starts above the screen
	)
