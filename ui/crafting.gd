extends Control
class_name CraftingSystem

@onready var recipe_scene = preload("res://ui/RecipeRow.tscn")
@export var rows: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_slots(rows)
	visible = false

	add_to_group("crafting")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_category(CraftingData.current_category)

func _input(event):
	if event.is_action_pressed("inventory"):
		self.visible = !(self.visible)
		if self.visible:
			CraftingData.sort_recipes()
			_update_list()

func _setup_slots(rows: int):
	for row in rows:
		var slot = recipe_scene.instantiate()
		$Recipes.add_child(slot)
	
	for category in $Categories.get_children():
		if category.name.to_lower() == CraftingData.current_category:
			category.enable()
		else:
			category.disable() 

func _update_list():
	var recipe_rows = $Recipes.get_children()
	var start = 0
	
	print(InventoryData.craftable)
	print(InventoryData.uncraftable)
	print()
	
	var recipe
	var i = start
	for row in recipe_rows:
		if i < len(CraftingData.craftable):
			recipe = CraftingData.craftable[i]
			row.set_recipe(recipe, true)
		elif i < (len(CraftingData.craftable) + len(CraftingData.uncraftable)):
			recipe = CraftingData.uncraftable[i - len(CraftingData.craftable)]
			row.set_recipe(recipe, false)
		else:
			row.clear_recipe()
		
		i += 1

func set_category(category: String):
	for button in $Categories.get_children():
		if button.category == category:
			button.enable()
		else:
			button.disable()
	CraftingData.sort_recipes()
	_update_list()
