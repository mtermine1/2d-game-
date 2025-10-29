extends Node

var grandma_dead := false

func _ready():
	var grandma = get_node("../Grandma")
	grandma.connect("grandma_died", Callable(self, "_on_grandma_died"))

func _on_grandma_died():
	grandma_dead = true
	print("Grandma is dead — exit unlocked!")

func can_complete_level() -> bool:
	return grandma_dead
