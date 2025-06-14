extends CanvasLayer

var next_scene = "res://screens/DreamGame.tscn"

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene)

func _on_timer_timeout():
	if ResourceLoader.load_threaded_get_status(next_scene) == 3:
		var scene = ResourceLoader.load_threaded_get(next_scene)
		get_tree().root.add_child(scene.instantiate())
		queue_free()
	else:
		$Timer.start(1)
