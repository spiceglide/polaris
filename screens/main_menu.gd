extends Node2D

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://screens/LoadingScreen.tscn")

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://screens/LoadingScreen.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://screens/SettingsMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://screens/QuitMenu.tscn")
