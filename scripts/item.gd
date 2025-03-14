extends Container
class_name Item

@export var id: String = ""
@export var title: String = ""
@export var description: String = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	add_to_group("items")
