extends Node

@onready var size = 5*5

var slots: Array[String]
var selected_slot: int = 0
var item_map: Dictionary = {}
var recipe_map: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots.resize(size)
	select_slot(0)
	
	item_map = _read_items()
	
	add_to_group("crafting")
	
	set_item(0, "sleeping_bag")
	set_item(1, "berries")
	set_item(2, "berries")

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

func set_item_at_first_empty(item: String) -> bool:
	return set_item(get_first_empty_slot(), item)
	
func set_item_at_selected(item: String) -> bool:
	return set_item(selected_slot, item)

func get_first_empty_slot():
	for i in range(len(slots)):
		if not slots[i]:
			return i

func get_item(index: int):
	return slots[index]

func get_all_items():
	return slots.filter(
		func(item): return not item.is_empty()
	)

func select_slot(index: int):
	selected_slot = index

func clear_slot(index: int):
	slots[index] = ""

func remove_items(items: Array):
	var to_remove = items.duplicate()
	
	for i in range(len(slots)):
		if to_remove.is_empty():
			return
		
		if to_remove.has(slots[i]):
			slots[i] = ""
			to_remove.erase(slots[i])

func set_recipes(recipes: Array):
	self.recipe_map = {}
	
	for recipe in recipes:
		self.recipes[recipe["out"]] = recipe["in"]

func craft_complete(product: String):
	for recipe in CraftingData.recipes:
		if product == recipe["out"]:
			remove_items(recipe["in"])
			return
