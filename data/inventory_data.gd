extends Node

@onready var size = 5*5

var inventory: Storage
var selected_slot: LogicalSlot
var recipe_map: Dictionary = {}

var collectables: Dictionary = {}

var station = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = Storage.new(size)
	selected_slot = inventory.slots[0]
	
	if WorldData.get_game_mode() == "overworld":
		inventory.push(GameItem.new("cellar"))
		inventory.push(GameItem.new("sleepingbag"))
		inventory.push(GameItem.new("hatcher"))
		inventory.push(GameItem.new("shovel"))
		inventory.push(GameItem.new("spear"))
		inventory.push(GameItem.new("clay"), 2)
	
	add_to_group("crafting")

func use_selected_item() -> bool:
	var item := selected_slot.item
	var tags = item.get("tags")
	
	if tags and "consumable" in tags:
		print(item)
		inventory.pop(item, 1, [selected_slot])
	
	var stats = item.get("stats")
	if stats:
		PlayerData.health += stats.get("health", 0)
		PlayerData.hunger += stats.get("hunger", 0)
		PlayerData.thirst += stats.get("thirst", 0)
		PlayerData.warmth += stats.get("warmth", 0)
		PlayerData.sanity += stats.get("sanity", 0)
	
	var yields = item.get("yields")
	if yields:
		for gift in yields:
			inventory.push(gift)
	
	return true

func get_item(slot: int) -> GameItem:
	return inventory.slots[slot].item

func get_quantity(slot: int) -> int:
	return inventory.slots[slot].quantity

func get_selected_item() -> GameItem:
	return selected_slot.item

func get_all_items() -> Array[GameItem]:
	var items: Array[GameItem] = []
	for slot in inventory.slots:
		if slot.item:
			items.append(slot.item)
	return items

func select_slot(index: int):
	selected_slot = inventory.slots[index]
	$AudioStreamPlayer.play()

func set_recipes(recipes: Array):
	self.recipe_map = {}
	
	for recipe in recipes:
		self.recipes[recipe["out"]] = recipe["in"]

func craft_complete(product: GameItem):
	for recipe in CraftingData.recipes:
		if product == recipe["out"]:
			for item in recipe["out"]:
				inventory.pop(GameItem.new(item))
