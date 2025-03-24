extends Control
class_name CraftingSystem

@onready var recipe_scene = preload("res://ui/RecipeRow.tscn")
@onready var inventory: InventorySystem = HUD.get_node("Inventory")

@export var rows: int = 5
var slots = inventory.slots

var recipes: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_slots()
	visible = false
	
	var file = FileAccess.open("res://data/recipes.json", FileAccess.READ)
	var json = file.get_as_text()
	
	var reader = JSON.new()
	var error = reader.parse(json)
	if error == OK:
		recipes = reader.data
	else:
		print("JSON Parse Error: %s at %s" % [reader.get_error_message(), reader.get_error_line()])
		
	recipes.sort_custom(func(a, b): return len(a["in"]) > len(b["in"]))
	
	for recipe in recipes:
		recipe["in"].sort()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("inventory"):
		self.visible = !(self.visible)

func _setup_slots():
	var anims = ["type1", "type2", "type3", "type4", "type5"]
	
	for row in rows:
		var slot = recipe_scene.instantiate()
		$Recipes.add_child(slot)
		slots.append(slot)

func craft(ingr_slots: Array) -> bool:
	var ingredients = []
		
	for ingr_slot in ingr_slots:
		var ingr = slots[ingr_slot].get_item()
		if ingr:
			print("%s: %s" % [ingr_slot, ingr])
			ingredients.append(ingr)
		else:
			return false
			
	ingredients.sort()
	print()
		
	for recipe in recipes:
		if ingredients == recipe["in"]:
			slots[ingr_slots[0]].set_item(recipe["out"])
			print(recipe["out"])
			for i in ingr_slots.slice(1):
				slots[i].clear_item()
		
	return true
