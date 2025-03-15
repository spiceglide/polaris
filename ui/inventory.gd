extends Control
class_name InventorySystem

@onready var slot_scene = preload("res://ui/Slot.tscn")
@onready var item_scene = preload("res://ui/Item.tscn")

@export var cols: int = 5
@export var rows: int = 5
var slots: Array[InventorySlot] = []
var anims: Array[String] = ["type1", "type2", "type3", "type4", "type5"]
var selected_slot: int = 0

var recipes: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_slots()
	_setup_crafting()
	select(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("inventory"):
		$Full.visible = !($Full.visible)
		
	if event.is_action_pressed("hotbar"):
		select(event.as_text().to_int() - 1)
		
	if event.is_action_pressed("inv_next"):
		select((selected_slot + 1) % cols)
		
	if event.is_action_pressed("inv_prev"):
		select(fposmod(selected_slot - 1, cols))
		
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
	hint.get_node("Sprite").scale = Vector2(0.7, 0.7)
	hint.scale.x = 0.25
	$Hotbar.add_child(hint)
	
func _setup_crafting():
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

func select(slot_index: int):
	slots[selected_slot].deselect()
	selected_slot = slot_index
	slots[selected_slot].select()

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
			select(ingr_slots[0])
			print(recipe["out"])
			for i in ingr_slots.slice(1):
				slots[i].clear_item()
		
	return true
