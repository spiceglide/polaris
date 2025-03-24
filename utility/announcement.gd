extends Control

@export var announcement = ""
@export var announcement_timeout = 2.5
@export var idle_chatter = []
@export var chatter_interval = 5
@export var chatter_odds = 0.5
var announcement_timer = 0
var speech_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	announcement = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	announcement_timer += delta
	if announcement_timer > announcement_timeout:
		self.text = ""
		
	if not idle_chatter.is_empty():
		speech_timer += 1
		if speech_timer > chatter_interval*60 and announcement == "":
			if randf() < chatter_odds:
				var chatter = idle_chatter.pick_random()
				announce(chatter)
			speech_timer = 0

func announce(text: String):
	announcement_timer = 0
	self.text = text
