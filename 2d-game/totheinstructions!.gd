extends Button


func _ready() -> void:
	self.modulate.a = 0.0
	# Connect the button's pressed signal to the function
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://instructions.tscn")
