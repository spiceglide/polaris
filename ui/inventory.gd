extends Control
class_name InventorySystem

@onready var slot_scene = preload("res://ui/slots/Slot.tscn")
@onready var item_scene = preload("res://ui/Item.tscn")
@onready var hint_scene = preload("res://ui/slots/HintButton.tscn")

@export var cols: int = 5
@export var rows: int = 5
var slots: Array[ItemSlot] = []
var selected_slot: int = 0
var last_checked = INF

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_slots()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	select(InventoryData.selected_slot)
	
	for i in range(len(slots)):
		var slot = slots[i]
		var slot_data = InventoryData.get_item(i)
		
		# Acknowledge modified slots
		var timestamp = Time.get_ticks_msec()
		if last_checked < slot.last_used:
			if slot.item:
				InventoryData.set_item(i, slot.item.item_id)
			else:
				InventoryData.clear_slot(i)
			
			continue
		
		if slot_data:
			slot.set_item(slot_data)
		else:
			slot.clear_item()
	
	last_checked = Time.get_ticks_msec()

func _input(event):
	if event.is_action_pressed("inventory"):
		$Full.visible = !($Full.visible)
		$Trash.visible = !($Trash.visible)
		
	if event.is_action_pressed("hotbar"):
		InventoryData.select_slot(event.as_text().to_int() - 1)
		
	if event.is_action_pressed("inv_next"):
		InventoryData.select_slot((selected_slot + 1) % cols)
		
	if event.is_action_pressed("inv_prev"):
		InventoryData.select_slot(fposmod(selected_slot - 1, cols))
		
	if event.is_action_pressed("drop"):
		InventoryData.clear_slot(selected_slot)

func set_item(slot_index: int, item: String):
	var slot = slots[slot_index]
	slot.set_item(item)

func clear_item(slot_index: int):
	var slot = slots[slot_index]
	slot.clear_item()

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
