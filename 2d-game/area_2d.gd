extends Area2D

signal level_completed

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		var grandma = get_tree().current_scene.get_node_or_null("Grandma")
		
		# Safety: if Grandma node exists and is still alive, block completion
		if grandma and grandma.health > 0:
			print("You can’t leave yet — Grandma is still alive!")
			return

		# Otherwise allow level completion
		print("Level Complete! 🎵")
		emit_signal("level_completed")
		get_tree().change_scene_to_file("res://scenes/level_complete_screen.tscn")
