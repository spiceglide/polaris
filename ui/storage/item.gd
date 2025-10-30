extends Node
class_name GameItem

@export var id: String
@export var max_stack: int = 7

func _init(id: String) -> void:
	self.id = id

func _get(property: StringName) -> Variant:
	var data = InventoryData.get_item_data(id)
	var prop = data.get(property, null)
	if prop == null:
		print("ERROR: Property '%' not found in item '%'" % [property, id])
	return prop

func equals(other: GameItem) -> bool:
	return (self.id == other.id)
