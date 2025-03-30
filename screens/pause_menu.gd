extends CanvasLayer

@onready var settings_menu = preload("res://screens/SettingsMenu.tscn").instantiate()

var time = HUD.get_node("Time")
var paused: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	unpause()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		unpause() if paused else pause()

func pause():
	paused = true
	get_tree().paused = true
	$Control.visible = true

func unpause():
	var settings = self.get_node("SettingsMenu")
	if settings:
		self.remove_child(settings)
		settings.queue_free()
	
	paused = false
	get_tree().paused = false
	$Control.visible = false

func _on_resume_pressed() -> void:
	unpause()

func _on_options_pressed() -> void:
	settings_menu.layer = 2
	self.add_child(settings_menu)

func _on_quit_pressed() -> void:
	queue_free()
	get_tree().change_scene_to_file("res://screens/MainMenu.tscn")
