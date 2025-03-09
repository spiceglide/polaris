extends CanvasLayer

@export var padding = 10
var viewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	viewport = get_viewport().size
	$Health.position.x = padding
	$"Inventory HUD".position.x = (viewport.x / 2) - 175
	$"Inventory HUD".position.y = (viewport.y) - (5 * padding) 
