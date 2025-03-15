extends Node2D
class_name Item

@export var id: String = ""
@export var title: String = ""
@export var description: String = ""

var item_map

func _ready() -> void:
	var file = FileAccess.open("res://data/items.json", FileAccess.READ)
	var json = file.get_as_text()
	
	var reader = JSON.new()
	var error = reader.parse(json)
	if error == OK:
		item_map = reader.data
	else:
		print("JSON Parse Error: %s at %s" % [reader.get_error_message(), reader.get_error_line()])
	
	add_to_group("items")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_item(id: String):
	var data = item_map[id]
	id = id
	title = data["name"]
	description = data["description"]
