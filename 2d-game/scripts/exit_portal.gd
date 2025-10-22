extends Area2D

@export var next_scene_path := "res://Level3/Level3_Cop.tscn"

func _on_body_entered(body):
    if body and body.name.matchn("*Player*"):
        _go_next()

func _go_next():
    var fade := get_tree().root.get_node_or_null("FadeLayerGlobal")
    # If you don't have a global fade, do a simple change for now:
    get_tree().change_scene_to_file(next_scene_path)
