extends Node2D

@onready var options_menu = preload("res://screens/SettingsMenu.tscn").instantiate()
@onready var quit_menu = preload("res://screens/QuitMenu.tscn").instantiate()

func _on_continue_pressed() -> void:
	queue_free()
	get_tree().change_scene_to_file("res://screens/LoadingScreen.tscn")

func _on_new_game_pressed() -> void:
	queue_free()
	get_tree().change_scene_to_file("res://screens/LoadingScreen.tscn")

func _on_options_pressed() -> void:
	self.add_child(options_menu)

func _on_quit_pressed() -> void:
	self.add_child(quit_menu)
