extends Node2D

@export var parent: CollisionObject2D = self.get_parent()
var priority: Array = ["chop", "dig", "crank", "gather", "operate"]

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

func highlight(enabled: bool, available: Array = []):
	# Item requirements
	var notifications = parent.get_node_or_null("Notifications")
	if notifications and enabled:
		notifications.visible = true
	if notifications and not enabled:
		notifications.visible = false

	# Highlight object
	if enabled and select_interaction_type(available):
		parent.highlight(true)
	else:
		parent.highlight(false)

func select_interaction_type(available: Array) -> String:
	var object_data = data[parent.id.to_lower()]
	var state_data = object_data[parent.get_current_state()]
	var possible = state_data.keys()

	if not has_required_items():
		return ""

	var type: String = ""
	for interaction_type in priority:
		if (interaction_type in available) and (interaction_type in possible):
			type = interaction_type
			break
	
	return type

func interact(player: CharacterBody2D, type: String):
	var state: String = parent.get_current_state()
	
	var state_data := get_state_data()
	var interaction_data: Dictionary = state_data[type]

	# Does the interaction require any items?
	var required := has_required_items()
	if required:
		var requires: Array[GameItem]
		requires.assign(state_data.get("requires", []).map(func (x): return GameItem.new(x)))
		for req in requires:
			InventoryData.inventory.pop(req, 1)
	else:
		return

	# Get yields
	var yields = interaction_data.get("yields", [])
	var announcer = player.get_node("Notifications")
	for item in yields:
		if InventoryData.inventory.push(GameItem.new(item), 1):
			announcer.announce_items([item])

	# State transition
	var next_state = interaction_data.get("next", state)
	match next_state:
		state:
			pass
		"":
			parent.queue_free()
		_:
			parent.change_state(next_state)

func get_state_data(state: Variant = null) -> Dictionary:
	var id = parent.id.to_lower()
	if not state:
		state = parent.get_current_state()

	var object_data = data[id]
	var state_data = object_data[state]

	return state_data

func _on_state_machine_transitioned(state: String) -> void:
	var notifications = parent.get_node_or_null("Notifications")
	if notifications:
		var state_data = get_state_data(state)
		var requires = state_data.get("requires", [])
		notifications.clear_text()
		notifications.announce_items(requires)

func get_structure_id() -> String:
	return parent.id

func get_inventory() -> Storage:
	return parent.inventory

func has_required_items() -> bool:
	var state_data := get_state_data()

	# Does the interaction require any items?
	var requires: Array[GameItem]
	requires.assign(state_data.get("requires", []).map(func (x): return GameItem.new(x)))
	if CraftingData.is_subset(requires, InventoryData.get_all_items()):
		return true
	else:
		return false
