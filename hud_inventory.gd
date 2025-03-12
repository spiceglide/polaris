extends Node2D

@export var slot_count = 5
@export var spacing = 100
var inventory = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for slot in $Hotbar.get_children():
		slot.play()
		
	for slot in $Full.get_children():
		slot.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if Input.is_action_just_pressed("inventory"):
		$Full.visible = !($Full.visible)
