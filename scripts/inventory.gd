extends Control
class_name InventorySystem

@onready var slot_scene = preload("res://scenes/slot.tscn")
@onready var item_scene = preload("res://scenes/item.tscn")

@export var cols: int = 5
@export var rows: int = 5
var slots: Array[InventorySlot] = []
var anims: Array[String] = ["type1", "type2", "type3", "type4", "type5"]
var selected_slot: int = 0

var recipe_map: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_err = self.connect("item_pick_up",self,"item_pick_up")
	_setup_slots()
	_setup_crafting()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("inventory"):
		$Full.visible = !($Full.visible)
		
	if event.is_action_pressed("hotbar"):
		selected_slot = event.as_text().to_int() - 1
		
	if event.is_action_pressed("drop"):
		slots[selected_slot].clear_item()
		
	if event.is_action_pressed("craft"):
		var ingredients = []
		for i in range(max(5, cols)):
			var ingr = slots[i].get_item()
			if ingr:
				ingredients.append(i)
			else:
				break
		craft(ingredients)

func set_item(item_id: String) -> bool:
	var slot = slots[selected_slot]
	if slot.item == null:
		slot.set_item(item_id)
		print("Picked up '" + item_id + "'")
		return true
	else:
		return false

func _setup_slots():
	$Full.columns = cols
	
	if rows >= 1:
		for col in cols:
			var slot = slot_scene.instantiate()
			slot.anim = anims[col % len(anims)]
			$Hotbar.add_child(slot)
			slots.append(slot)
		
		for row in range(rows - 1):
			for col in range(cols):
				var slot = slot_scene.instantiate()
				slot.anim = anims[col % len(anims)]
				$Full.add_child(slot)
				slots.append(slot)
	
	var hint = slot_scene.instantiate()
	hint.anim = "hint"
	$Hotbar.add_child(hint)
	
func _setup_crafting():
	var file = FileAccess.open("res://data/recipes.json", FileAccess.READ)
	var json = file.get_as_text()
	
	var reader = JSON.new()
	var error = reader.parse(json)
	if error == OK:
		recipe_map = reader.data
	else:
		print("JSON Parse Error: %s at %s" % [reader.get_error_message(), reader.get_error_line()])
		
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
	#print(ingredients)
		
	for item in recipe_map:
		var recipe_ingredients = recipe_map[item]["ingredients"]
		recipe_ingredients.sort()
		
		if ingredients == recipe_ingredients:
			slots[ingr_slots[0]].set_item(item)
			print(item)
			#ingredients[slots[0]] = item
			for i in ingr_slots.slice(1):
				slots[i].clear_item()
		
	return true
