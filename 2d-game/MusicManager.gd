# MusicManager.gd
extends Node

@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	# Add the player to this autoload node
	add_child(player)

	# Load your background music
	player.stream = preload("res://822773__nomisylad__cool-funky-night-time-bossa-nova-guitar-vibe.wav")  # ← change this to your music file path


	# Make it loop and start automatically
	player.autoplay = true
	player.volume_db = -3  # adjust volume if needed
	player.play()
