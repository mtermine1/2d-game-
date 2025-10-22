extends Node2D
signal alarm(player_position: Vector2)

@export var sweep_speed_deg := 50.0
@export var on_time := 1.0
@export var off_time := 1.0

@onready var cone_area: Area2D = $ConeArea
var active := true

func _ready():
    _loop()

func _process(delta):
    rotation_degrees += sweep_speed_deg * delta

func _loop():
    while true:
        active = true
        cone_area.monitoring = true
        await get_tree().create_timer(on_time).timeout
        active = false
        cone_area.monitoring = false
        await get_tree().create_timer(off_time).timeout

func _on_ConeArea_body_entered(body):
    if active and body and body.name.matchn("*Player*"):
        emit_signal("alarm", body.global_position)
