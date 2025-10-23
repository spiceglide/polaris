extends Node

@onready var size = 5*5

var slots: Array[String]
var selected_slot: int = 0
var recipe_map: Dictionary = {}

var collectables: Dictionary = {}

var station = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots.resize(size)
	select_slot(0)
	
	add_to_group("crafting")
	
	if WorldData.get_game_mode() == "overworld":
		set_item(0, "berrybush")
		set_item(4, "sleepingbag")
		set_item(5, "hatchet")
		set_item(6, "shovel")
		set_item(7, "spear")
		set_item(8, "clay")
		set_item(9, "clay")

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

func get_item_data(item: String):
	return $ItemsData.get_data(item)

func get_selected_item_data() -> Dictionary:
	var item = slots[selected_slot]
	var data = $ItemsData.get_data(item)
	return data

func use_selected_item():
	var item = slots[selected_slot]
	var data = $ItemsData.get_data(item)
	
	if "consumable" in data.get("tags", []):
		print(item)
		clear_slot(selected_slot)
	
	if "stats" in data:
		PlayerData.health += data["stats"].get("health", 0)
		PlayerData.hunger += data["stats"].get("hunger", 0)
		PlayerData.thirst += data["stats"].get("thirst", 0)
		PlayerData.warmth += data["stats"].get("warmth", 0)
		PlayerData.sanity += data["stats"].get("sanity", 0)
	
	if "yields" in data:
		for gift in data.get("yields", []):
			set_item_at_first_empty(gift)
		
	if "events" in data:
		var flags = data.get("events", {})
		for flag in data.get("events", {}):
			PlayerData.flags[flag] = flags[flag]

func get_selected_item():
	return slots[selected_slot]

func get_all_items():
	return slots.filter(
		func(item): return not item.is_empty()
	)

func select_slot(index: int):
	selected_slot = index
	$AudioStreamPlayer.play()

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
