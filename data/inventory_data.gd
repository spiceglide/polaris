extends Node

@onready var size = 5*5

var slots: Array[String]
var selected_slot: int = 0
var item_map: Dictionary = {}
var recipe_map: Dictionary = {}

var collectables: Dictionary = {}

var holdable = ["torch", "hatchet"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots.resize(size)
	select_slot(0)
	
	item_map = _read_items()
	
	add_to_group("crafting")
	
	if WorldData.get_game_mode() == "overworld":
		set_item(0, "hatchet")
		set_item(1, "frog")
		set_item(4, "sleeping_bag")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	if not slots[slot]:
		slots[slot] = item
		return true
	return false

func set_item_at_first_empty(item: String, start: int = 0) -> bool:
	var slot = get_first_empty_slot(start)
	if slot != null:
		return set_item(slot, item)
	else:
		return false

func set_item_at_selected(item: String, start: int = 0) -> bool:
	return set_item(selected_slot, item)

func move_item_to_first_empty(slot: int, start: int = 0) -> bool:
	var item = get_item(slot)
	if set_item_at_first_empty(item, start):
		clear_slot(slot)
		return true
	return false

func get_first_empty_slot(start: int = 0):
	for i in range(start, len(slots)):
		if not slots[i]:
			return i

func get_item(index: int):
	return slots[index]

func get_selected_item():
	return slots[selected_slot]

func get_all_items():
	return slots.filter(
		func(item): return not item.is_empty()
	)

func select_slot(index: int):
	selected_slot = index

func clear_slot(index: int):
	slots[index] = ""

func move_item(source: int, dest: int):
	slots[dest] = slots[source]
	slots[source] = ""

func swap_items(source: int, dest: int):
	var source_item = slots[source]
	var dest_item = slots[dest]
	
	slots[dest] = source_item
	slots[source] = dest_item

func remove_items(items: Array):
	var to_remove = items.duplicate()
	
	for i in range(len(slots)):
		if to_remove.is_empty():
			return
		
		if to_remove.has(slots[i]):
			to_remove.erase(slots[i])
			slots[i] = ""

func set_recipes(recipes: Array):
	self.recipe_map = {}
	
	for recipe in recipes:
		self.recipes[recipe["out"]] = recipe["in"]

func craft_complete(product: String):
	for recipe in CraftingData.recipes:
		if product == recipe["out"]:
			remove_items(recipe["in"])
			return
