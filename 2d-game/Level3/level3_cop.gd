extends Node2D

func _ready():
	# Create a test player as a simple moving square
	var player = ColorRect.new()
	player.color = Color(0.2, 0.6, 1)
	player.size = Vector2(40, 40)
	player.position = Vector2(100, 300)
	add_child(player)

	# Ground
	var ground = ColorRect.new()
	ground.color = Color(0.2, 0.2, 0.2)
	ground.size = Vector2(800, 40)
	ground.position = Vector2(0, 400)
	add_child(ground)

	# Label
	var label = Label.new()
	label.text = "Level 3 – Cop Encounter | Move with arrows | R to restart"
	label.position = Vector2(16, 16)
	add_child(label)

	set_process(true)
	self.player = player

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		self.player.position.x += 200 * delta
	elif Input.is_action_pressed("ui_left"):
		self.player.position.x -= 200 * delta

	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()
