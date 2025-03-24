extends Control
class_name CraftingSystem

@onready var recipe_scene = preload("res://ui/RecipeRow.tscn")
@onready var inventory: InventorySystem = HUD.get_node("Inventory")

@export var rows: int = 5
@export var current_category = "all"
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
		self.visible = !(self.visible)
		if self.visible:
			_sort_recipes()
			_update_list()

func _setup_slots():
	for row in rows:
		var slot = recipe_scene.instantiate()
		$Recipes.add_child(slot)
	
	for category in $Categories.get_children():
		if category.name.to_lower() == current_category:
			category.enable()
		else:
			category.disable() 

func _sort_recipes():
	# TODO: consider item category
	var all_items = inventory.get_all_items()
	craftable = []
	uncraftable = []
	
	for recipe in recipes:
		if (recipe["category"] != current_category) and (current_category != "all"):
			continue
		
		if is_subset(recipe["in"], all_items):
			craftable.append(recipe)
		else:
			uncraftable.append(recipe)

func _update_list():
	var recipe_rows = $Recipes.get_children()
	var start = 0
	
	var recipe
	var i = start
	for row in recipe_rows:
		if i < len(craftable):
			recipe = craftable[i]
			row.set_recipe(recipe, true)
		elif i < (len(craftable) + len(uncraftable)):
			recipe = uncraftable[i - len(craftable)]
			row.set_recipe(recipe, false)
		else:
			row.clear_recipe()
		
		i += 1

func is_subset(array1: Array, array2: Array) -> bool:
	for item in array1:
		if item not in array2:
			return false
	return true
