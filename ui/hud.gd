extends CanvasLayer

@export var announcement = ""
@export var announcement_timeout = 250
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	timer += 1
	
	if (timer > announcement_timeout) and ($Announcement.text == announcement):
		announcement = ""
		timer = 0

	$Announcement.text = announcement
