extends Control
class_name CraftingSystem

@onready var recipe_scene = preload("res://ui/RecipeRow.tscn")
@onready var inventory: InventorySystem = HUD.get_node("Inventory")

@export var rows: int = 5
var craftable = []
var uncraftable = []
var recipes: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(HUD)
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
		_sort_recipes()
		self.visible = !(self.visible)
		print(craftable)

func _setup_slots():
	var anims = ["type1", "type2", "type3", "type4", "type5"]
	
	for row in rows:
		var slot = recipe_scene.instantiate()
		$Recipes.add_child(slot)

func _sort_recipes():
	var all_items = inventory.get_all_items()
	craftable = []
	uncraftable = []
	
	for recipe in recipes:
		if is_subset(all_items, recipe["in"]):
			craftable.append(recipe)
		else:
			uncraftable.append(recipe)

func is_subset(array1: Array, array2: Array) -> bool:
	for item in array2:
		if !array1.has(item):
			return false
		if array2.count(item) != array1.count(item):
			return false
	return true
