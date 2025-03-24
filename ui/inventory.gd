extends Control
class_name InventorySystem

@onready var slot_scene = preload("res://ui/slots/Slot.tscn")
@onready var item_scene = preload("res://ui/Item.tscn")
@onready var hint_scene = preload("res://ui/slots/HintButton.tscn")

@export var cols: int = 5
@export var rows: int = 5
var slots: Array[InventorySlot] = []
var selected_slot: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_slots()
	select(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("inventory"):
		$Full.visible = !($Full.visible)
		$Trash.visible = !($Trash.visible)
		
	if event.is_action_pressed("hotbar"):
		select(event.as_text().to_int() - 1)
		
	if event.is_action_pressed("inv_next"):
		select((selected_slot + 1) % cols)
		
	if event.is_action_pressed("inv_prev"):
		select(fposmod(selected_slot - 1, cols))
		
	if event.is_action_pressed("drop"):
		slots[selected_slot].clear_item()

func set_item(item_id: String) -> bool:
	var slot = get_first_empty_slot()
	if slot:
		slot.set_item(item_id)
		print("Picked up '" + item_id + "'")
		return true
	else:
		return false

func get_first_empty_slot():
	for slot in slots:
		if not slot.item:
			return slot

func get_all_items():
	var items = []
	for slot in slots:
		var item = slot.get_item()
		if item:
			items.append(slot.get_item())
	return items

func _setup_slots():
	$Full.columns = cols
	
	if rows >= 1:
		for col in cols:
			var slot = slot_scene.instantiate()
			$Hotbar.add_child(slot)
			slots.append(slot)
		
		for row in range(rows - 1):
			for col in range(cols):
				var slot = slot_scene.instantiate()
				$Full.add_child(slot)
				slots.append(slot)
	
	var hint = hint_scene.instantiate()
	$Hotbar.add_child(hint)

func select(slot_index: int):
	slots[selected_slot].deselect()
	selected_slot = slot_index
	slots[selected_slot].select()
