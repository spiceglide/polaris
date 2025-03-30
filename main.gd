extends Node2D

var main_menu = preload("res://screens/MainMenu.tscn").instantiate()

func _ready() -> void:
	self.add_child(main_menu)
