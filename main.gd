extends Node2D

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0, 0, 0))
	SceneSwitcher.load_main_menu()
