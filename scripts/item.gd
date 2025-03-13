extends Node2D
class_name Item

@export var id: String = ""
@export var title: String = ""
@export var description: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	add_to_group("items")
