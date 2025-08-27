extends Node2D

signal interaction

@export var parent: PhysicsBody2D
var priority: Array = ["chop", "gather"]

var data: Dictionary = {}

func _ready() -> void:
	data = _read_items()
	add_to_group("interactive")

func _read_items():
	var file = FileAccess.open("res://data/objects.json", FileAccess.READ)
	var json = file.get_as_text()
	
	var reader = JSON.new()
	var error = reader.parse(json)
	if error == OK:
		return reader.data
	else:
		print("JSON Parse Error: %s at %s" % [reader.get_error_message(), reader.get_error_line()])
		return {}

func select_interaction_type(available: Array) -> String:
	var object_data = data[parent.id.to_lower()]
	var state_data = object_data[parent.current_state.name.to_lower()]
	var possible = state_data.keys()

	var type: String = ""
	for interaction_type in priority:
		if (interaction_type in available) and (interaction_type in possible):
			type = interaction_type
			break
	
	return type

func interact(player: CharacterBody2D, type: String):
	var object_data = data[parent.id.to_lower()]
	var state_data = object_data[parent.current_state.name.to_lower()]
	var interaction_data = state_data[type]

	var yields = interaction_data.get("yields", [])
	var announcer = player.get_node("Notifications")
	for item in yields:
		if InventoryData.set_item_at_first_empty(item):
			announcer.announce_items([item])

	var next_state = interaction_data.get("next", "")
	if next_state:
		parent.change_state(next_state)
