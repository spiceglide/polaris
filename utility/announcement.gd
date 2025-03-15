extends Control

@export var announcement = ""
@export var announcement_timeout = 2.5
var announcement_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	announcement = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	announcement_timer += delta
	
	if announcement_timer > announcement_timeout:
		self.text = ""

func announce(text: String):
	announcement_timer = 0
	self.text = text
