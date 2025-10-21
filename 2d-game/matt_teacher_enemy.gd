extends Node2D

@export var pencil_scene: PackedScene
@onready var throw_origin = $Marker2D
@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	var pencil = pencil_scene.instantiate()
	get_parent().add_child(pencil)
	pencil.global_position = throw_origin.global_position
	pencil.speed = -300.0  # or +300.0 depending on facing direction
