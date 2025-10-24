extends ProgressBar

@export var max_health := 3
var current_health := max_health

func _ready():
	value = current_health  # Start full health

func update_health(new_health: int):
	current_health = clamp(new_health, 0, max_health)
	value = current_health
