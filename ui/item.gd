extends Node2D
class_name Item

@export var item_id: String = ""
@export var title: String = ""
@export var description: String = ""

var item_map: Dictionary

func _ready() -> void:
	add_to_group("items")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_item(id: String):
	var data = InventoryData.item_map[id]
	item_id = id
	title = data["name"]
	description = data["description"]
