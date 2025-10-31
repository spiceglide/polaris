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
	var a1: Dictionary[String, int] = {}
	var a2: Dictionary[String, int] = {}
	
	for item in array1:
		a1[item.id] = a1.get(item.id, 0) + 1
	for item in array2:
		a2[item.id] = a2.get(item.id, 0) + 1
	
	for item in a1:
		if a2.get(item, 0) < a1[item]:
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

func craft_complete(_product: GameItem, _inputs: Array[GameItem]):
	sort_recipes()

func _apply_station(station: String):
	self.station = station
