extends CanvasLayer

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://screens/MainGame.tscn")
