extends Node

var data: Dictionary = {}

func _ready() -> void:
	data = _read_items()

func _read_items():
	var file = FileAccess.open("res://data/items.json", FileAccess.READ)
	var json = file.get_as_text()
	
	var reader = JSON.new()
	var error = reader.parse(json)
	if error == OK:
		return reader.data
	else:
		print("JSON Parse Error: %s at %s" % [reader.get_error_message(), reader.get_error_line()])
		return {}

func set_item(slot: int, item: String) -> bool:
	var slots = InventoryData.slots
	if not slots[slot]:
		slots[slot] = item
		return true
	return false

func set_item_at_first_empty(item: String, start: int = 0) -> bool:
	var slot = InventoryData.get_first_empty_slot(start)
	if slot != null:
		return InventoryData.set_item(slot, item)
	else:
		return false

func set_item_at_selected(item: String, start: int = 0) -> bool:
	var selected_slot = InventoryData.selected_slot
	return InventoryData.set_item(selected_slot, item)

func move_item_to_first_empty(slot: int, start: int = 0) -> bool:
	var item = InventoryData.get_item(slot)
	if InventoryData.set_item_at_first_empty(item, start):
		InventoryData.clear_slot(slot)
		return true
	return false

func get_data(item: String) -> Dictionary:
	return data.get(item, {})
