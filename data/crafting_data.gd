extends Node

@export var rows: int = 5
@export var current_category = "all"

var station: String = ""
var recipes: Array = []
var craftable = []
var uncraftable = []

func _ready() -> void:
	recipes = read_recipes()
	recipes.sort_custom(func(a, b): len(a["in"]) > len(b["in"]))
	for recipe in recipes:
		recipe["in"].sort()

func _process(_delta: float) -> void:
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
	var all_items := InventoryData.get_all_items()
	craftable = []
	uncraftable = []
	
	var usable_recipes = recipes.filter(_filter_stations)
	for recipe in usable_recipes:
		# Filter by category
		if (current_category != "all") and (current_category != recipe["category"]):
			continue
		
		var input: Array[GameItem] 
		input.assign(recipe["in"].map(func (x): return GameItem.new(x)))
		if is_subset(input, all_items):
			craftable.append(recipe)
		else:
			uncraftable.append(recipe)
			
func is_subset(array1: Array[GameItem], array2: Array[GameItem]) -> bool:
	var a1 := array1.map(func (x: GameItem): return x.id)
	var a2 := array2.map(func (x: GameItem): return x.id)
	
	for item in a1:
		if item not in a2:
			return false
	return true

func set_category(category: String):
	self.current_category = category

func _filter_stations(recipe: Dictionary) -> bool:
	var stations: Array = recipe.get("stations", [])
	
	# No station necessary
	if len(stations) == 0:
		return true
	
	# Usable station nearby
	if self.station in stations:
		return true
	return false

func craft_complete(product: String):
	sort_recipes()

func _apply_station(station: String):
	self.station = station
