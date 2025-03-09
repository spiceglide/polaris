extends Node2D

@export var slot_count = 5
@export var spacing = 100
var inventory = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Slot1.play()
	$Slot2.play()
	$Slot3.play()
	$Slot4.play()
	$Slot5.play()
	$Hint.play()
	for slot in range(slot_count):
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for item in inventory.slice(0, slot_count):
		pass
