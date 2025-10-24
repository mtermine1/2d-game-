extends Area2D

signal level_completed

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Level Complete! 🎵")
		emit_signal("level_completed")
		get_tree().change_scene_to_file("res://scenes/level_complete_screen.tscn")
