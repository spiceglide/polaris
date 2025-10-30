extends Node

@onready var size = 5*5

var slots: Array[Dictionary]
var selected_slot: int = 0
var recipe_map: Dictionary = {}

var collectables: Dictionary = {}

var station = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots.resize(size)
	for slot in slots:
		slot = {'item': null, 'quantity': null}
	select_slot(0)
	
	add_to_group("crafting")
	
	if WorldData.get_game_mode() == "overworld":
		set_item(0, "cellar")
		set_item(4, "sleepingbag")
		set_item(5, "hatchet")
		set_item(6, "shovel")
		set_item(7, "spear")
		set_item(8, "clay")
		set_item(9, "clay")

func push(item: String, amount: int = 1, slots: Array[Dictionary] = self.slots) -> bool:
	var firstEmpty: int
	for i in range(len(slots)):
		if not firstEmpty and slots[i]["item"].is_empty():
			firstEmpty = i
		elif slots[i] == item:
			while (amount > 0) and (slots[i]["amount"] <= 7):
				slots[i]["amount"] += 1
				amount -= 1
	# Leftover items after stack fills up
	if amount > 0:
		if firstEmpty:
			slots[firstEmpty]["item"] = item
			slots[firstEmpty]["amount"] = amount
		else:
			# TODO: drop remaining items
			return false
	
	return true

func pop(item: String, amount: int = 1, slots: Array[Dictionary] = self.slots) -> bool:
	for i in range(len(slots), 0, -1):
		if slots[i]["item"] == item:
			while (amount > 0) and (slots[i]["quantity"] > 0):
				amount -= 1
				slots[i]["quantity"] -= 1
	# Are we popping more items than the inventory contains?
	if amount <= 0:
		return true
	return false

func swap(slotA: int, slotB: int) -> bool:
	var dataA := slots[slotA]
	slots[slotA] = slots[slotB]
	slots[slotB] = dataA
	return true

func clever_swap(slotA: int, slotB: int):
	if slots[slotA]["item"] != slots[slotB]["item"]:
		swap(slotA, slotB)
	else:
		while slots[slotB]["amount"] < 7:
			slots[slotB]["quantity"] += 1
			slots[slotA]["quantity"] -= 1

func set_item(slot: int, item: String, quantity: int = 1) -> bool:
	if not slots[slot]:
		slots[slot] = {"item": item, "quantity": quantity}
		return true
	return false

func get_item(index: int) -> String:
	return slots[index]["item"]

func get_item_data(item: String) -> Dictionary:
	return $ItemsData.get_data(item)

func get_selected_item_data() -> Dictionary:
	var item = slots[selected_slot]
	var data = $ItemsData.get_data(item)
	return data

func use_selected_item():
	var item = slots[selected_slot]["item"]
	var data = $ItemsData.get_data(item)
	
	if "consumable" in data.get("tags", []):
		print(item)
		pop(item, 1, [slots[selected_slot]])
	
	if "stats" in data:
		PlayerData.health += data["stats"].get("health", 0)
		PlayerData.hunger += data["stats"].get("hunger", 0)
		PlayerData.thirst += data["stats"].get("thirst", 0)
		PlayerData.warmth += data["stats"].get("warmth", 0)
		PlayerData.sanity += data["stats"].get("sanity", 0)
	
	if "yields" in data:
		for gift in data.get("yields", []):
			push(gift, 1)
		
	if "events" in data:
		var flags = data.get("events", {})
		for flag in data.get("events", {}):
			PlayerData.flags[flag] = flags[flag]

func get_selected_item() -> String:
	return slots[selected_slot]["item"]

func get_all_items() -> Array:
	return slots.filter(
		func(item): return not item.is_empty()
	)

func select_slot(index: int):
	selected_slot = index
	$AudioStreamPlayer.play()

func swap_items(source: int, dest: int):
	var source_item = slots[source]
	var dest_item = slots[dest]
	
	slots[dest] = source_item
	slots[source] = dest_item

func remove_items(items: Array):
	for item in items:
		pop(item, 1)

func is_slot_empty(index: int):
	return (slots[index]["item"] == "") or (slots[index]["quantity"] <= 0)

func set_recipes(recipes: Array):
	self.recipe_map = {}
	
	for recipe in recipes:
		self.recipes[recipe["out"]] = recipe["in"]

func craft_complete(product: String):
	for recipe in CraftingData.recipes:
		if product == recipe["out"]:
			remove_items(recipe["in"])
