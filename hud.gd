extends CanvasLayer

@export var padding = 10
@export var announcement = ""
@export var announcement_timeout = 250
var viewport
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
	
	viewport = get_viewport().size
	$Health.position.x = padding
	$Announcement.position.x = (viewport.x / 2) - 200
	$Announcement.position.y = (viewport.y) - (15 * padding)
	$"Inventory HUD".position.x = (viewport.x / 2) - 175
	$"Inventory HUD".position.y = (viewport.y) - (45 * padding)
