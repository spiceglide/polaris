extends CanvasLayer

var main_menu = preload("res://screens/MainMenu.tscn").instantiate()

func _on_yes_pressed() -> void:
	get_tree().quit()

func _on_no_pressed() -> void:
	get_tree().root.add_child(main_menu)
	self.free()
