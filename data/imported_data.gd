extends Node

var items: Dictionary = {}

func _ready() -> void:
	items = _read_data("res://data/items.json")

func _read_data(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var json = file.get_as_text()
	
	var reader = JSON.new()
	var error = reader.parse(json)
	if error == OK:
		return reader.data
	else:
		print("JSON Parse Error: %s at %s" % [reader.get_error_message(), reader.get_error_line()])
		return {}
