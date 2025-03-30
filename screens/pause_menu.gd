extends CanvasLayer

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
	paused = false
	get_tree().paused = false
	$Control.visible = false
