extends Node2D

@export var left_right_distance := 220.0
@export var speed := 80.0

var _dir := 1
var _origin_x := 0.0

func _ready():
    _origin_x = position.x

func _process(delta):
    position.x += _dir * speed * delta
    if position.x > _origin_x + left_right_distance:
        _dir = -1
    elif position.x < _origin_x - left_right_distance:
        _dir = 1
