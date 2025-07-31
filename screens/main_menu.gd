extends Node2D

@onready var options_menu = preload("res://screens/SettingsMenu.tscn").instantiate()
@onready var quit_menu = preload("res://screens/QuitMenu.tscn").instantiate()

var view = Vector2.ZERO
var pan_speed = 3.0

func _ready() -> void:
	$QuitMenu.visible = false
	focus("MainMenu")

func _physics_process(delta: float) -> void:
	$Camera2D.position = $Camera2D.position.lerp(view, pan_speed * delta)

func focus(source: String):
	view = Vector2.ZERO
	match source:
		"MainMenu":
			$MainMenu/Menu/VBoxContainer/NewGame.grab_focus()
			$MainMenu/Menu/VBoxContainer/Continue.grab_focus()
		"SettingsMenu":
			$MainMenu/Menu/VBoxContainer/Options.grab_focus()
		"QuitMenu":
			$MainMenu/Menu/VBoxContainer/Quit.grab_focus()

func _on_continue_pressed() -> void:
	SceneSwitcher.load_main_game()

func _on_new_game_pressed() -> void:
	SceneSwitcher.load_dream_game()

func _on_options_pressed() -> void:
	view = $SettingsMenu.offset
	$SettingsMenu/Menu/VBoxContainer/Back.grab_focus()

func _on_quit_pressed() -> void:
	$QuitMenu.visible = true
	
	view = $QuitMenu.offset
	$QuitMenu/Dialog/HBoxContainer/No.grab_focus()
