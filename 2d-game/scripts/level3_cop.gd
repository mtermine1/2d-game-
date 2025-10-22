extends Node2D

@export var ticket_scene: PackedScene
@export var handcuff_scene: PackedScene
@export var siren_scene: PackedScene
@export var police_car_scene: PackedScene
@export var microphone_scene: PackedScene

@onready var ticket_spawner: Node2D = $Spawners/TicketSpawner
@onready var handcuff_spawner: Node2D = $Spawners/HandcuffSpawner
@onready var siren_rig: Node2D = $Spawners/SirenRig
@onready var fade_layer: ColorRect = $UI/FadeLayer/ColorRect
@onready var hint_label: Label = $UI/HintLabel
@onready var player_start: Marker2D = $PlayerStart

var player: Node = null
var rng := RandomNumberGenerator.new()

func _ready():
    rng.randomize()
    # Basic onboarding hints
    _show_hint("Press [Shoot] to pop papers. Avoid the siren cone!")
    # Ensure player exists (assumes main scene instantiates player; fallback: do nothing)
    # If your project spawns the player externally, you can ignore this.
    # Place collectible
    var mic := microphone_scene.instantiate()
    mic.position = Vector2(1600, -64)
    add_child(mic)
    mic.connect("collected", Callable(self, "_on_level_completed"))

    # Spawn a siren
    var siren := siren_scene.instantiate()
    siren.position = Vector2(900, -120)
    add_child(siren)
    siren.connect("alarm", Callable(self, "_on_siren_alarm"))

    # Spawn a police car obstacle (optional safe platform jump timing)
    if police_car_scene:
        var car := police_car_scene.instantiate()
        car.position = Vector2(1100, 0)
        add_child(car)

    # Start ticket spawn timer
    $Spawners/TicketSpawner/Timer.start()
    # Handcuffs spawn only when alarm triggers OR rare timed tosses
    $Spawners/HandcuffSpawner/Timer.start()

func _show_hint(t: String, for_seconds := 4.0) -> void:
    hint_label.text = t
    hint_label.show()
    await get_tree().create_timer(for_seconds).timeout
    hint_label.hide()

func _spawn_ticket():
    if not ticket_scene:
        return
    var t = ticket_scene.instantiate()
    t.position = $Spawners/TicketSpawner.global_position
    add_child(t)

func _spawn_handcuff(target_position: Vector2):
    if not handcuff_scene:
        return
    var h = handcuff_scene.instantiate()
    h.position = $Spawners/HandcuffSpawner.global_position
    add_child(h)
    h.launch_towards(target_position)

func _on_TicketTimer_timeout():
    _spawn_ticket()

func _on_HandcuffTimer_timeout():
    # Rare random toss
    if rng.randf() < 0.33:
        var tgt = get_viewport().get_camera_2d()
        var pos = Vector2.ZERO
        if tgt:
            pos = tgt.get_screen_center_position()
        _spawn_handcuff(pos)

func _on_siren_alarm(player_position: Vector2):
    _spawn_handcuff(player_position)

func _on_level_completed():
    # Simple finish: fade out then go to title or back to main scene
    # Replace with your preferred end flow
    await _fade_to_black()
    get_tree().change_scene_to_file("res://MainScene.tscn")

func _fade_to_black(duration := 0.5):
    var tween := create_tween()
    fade_layer.color.a = 0.0
    tween.tween_property(fade_layer, "color:a", 1.0, duration)
    await tween.finished
