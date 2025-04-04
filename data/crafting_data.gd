extends Node

@export var rows: int = 5
@export var current_category = "all"

var recipes: Array
var craftable = []
var uncraftable = []

func _ready() -> void:
	recipes = read_recipes()
	for recipe in recipes:
		recipe["in"].sort()

func _process(delta: float) -> void:
	sort_recipes()

func read_recipes() -> Array:
	var file = FileAccess.open("res://data/recipes.json", FileAccess.READ)
	var json = file.get_as_text()
	
	var reader = JSON.new()
	var error = reader.parse(json)
	if error == OK:
		return reader.data
	else:
		print("JSON Parse Error: %s at %s" % [reader.get_error_message(), reader.get_error_line()])
		return []

func sort_recipes():
	var all_items = InventoryData.get_all_items()
	craftable = []
	uncraftable = []
	
	for recipe in recipes:
		# Filter by category
		if (current_category != "all") and (current_category != recipe["category"]):
			continue
		
		if is_subset(recipe["in"], all_items):
			craftable.append(recipe)
		else:
			uncraftable.append(recipe)
			
func is_subset(array1: Array, array2: Array) -> bool:
	for item in array1:
		if item not in array2:
			return false
	return true

func set_category(category: String):
	self.current_category = category

func craft_complete(product: String):
	sort_recipes()
