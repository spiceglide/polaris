extends CanvasLayer

@onready var settings_menu = preload("res://screens/SettingsMenu.tscn").instantiate()

var paused: bool = false

var view = Vector2.ZERO
var pan_speed = 3.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	focus("PauseMenu")
	unpause()

func _physics_process(delta: float) -> void:
	$Camera2D.position = $Camera2D.position.lerp(view, pan_speed * delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		unpause() if paused else pause()

func focus(source: String):
	view = Vector2.ZERO
	match source:
		"PauseMenu":
			$PauseMenu/Menu/VBoxContainer/Resume.grab_focus()
		"SettingsMenu":
			$PauseMenu/Menu/VBoxContainer/Options.grab_focus()

func pause():
	paused = true
	get_tree().paused = true
	focus("PauseMenu")
	self.visible = true

func unpause():
	paused = false
	get_tree().paused = false
	self.visible = false

func _on_resume_pressed() -> void:
	unpause()

func _on_options_pressed() -> void:
	view = $SettingsMenu.offset
	$SettingsMenu/Menu/VBoxContainer/Back.grab_focus()

func _on_quit_pressed() -> void:
	queue_free()
	get_tree().change_scene_to_file("res://screens/MainMenu.tscn")
