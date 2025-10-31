extends Control
class_name InventorySystem

@onready var slot_scene = preload("res://ui/slots/Slot.tscn")
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
func _process(_delta: float) -> void:
	select(InventoryData.selected_slot)
	
	for i in range(len(slots)):
		var slot := slots[i]
		var old_item := slot.item
		var new_item = InventoryData.get_item(i)
		
		# Update outdated slots
		# TODO: Fix this `true`
		if true or (not old_item.equals(new_item)):
			if not new_item:
				slot.clear_item()
			else:
				var quantity := InventoryData.get_quantity(i)
				slot.set_item(new_item, quantity)
	
	# Trash slot
	var old_item: GameItem = $Trash.item
	var new_item := InventoryData.trash.item
	# TODO: ditto
	if true or (not old_item.equals(new_item)):
		if not new_item:
			$Trash.clear_item()
		else:
			var quantity := InventoryData.trash.quantity
			$Trash.set_item(new_item, quantity)

func _input(event):
	if event.is_action_pressed("inventory"):
		toggle()
		
	if event.is_action_pressed("hotbar"):
		InventoryData.select_slot(event.as_text().to_int() - 1)
		var item = InventoryData.get_selected_item()
		if item:
			$Announcement.announce(item.tr_name())
		
	if event.is_action_pressed("inv_next"):
		InventoryData.select_slot((selected_slot + 1) % cols)
		var item = InventoryData.get_selected_item()
		if item:
			$Announcement.announce(item.tr_name())
	
	if event.is_action_pressed("inv_prev"):
		InventoryData.select_slot(fposmod(selected_slot - 1, cols))
		var item = InventoryData.get_selected_item()
		if item:
			$Announcement.announce(item.tr_name())
		
	if event.is_action_pressed("drop"):
		var slot := InventoryData.inventory.slots[InventoryData.selected_slot]
		InventoryData.inventory.pop(slot.item, 1, [slot])

func toggle():
	if $Full.visible:
		close()
	else:
		open()

func open():
	$Full.visible = true
	$Trash.visible = true
	$Announcement.visible = false

func close():
	$Full.visible = false
	$Trash.visible = false
	$Announcement.visible = true

func set_item(slot_index: int, item: GameItem):
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
	var counter = 0
	
	if rows >= 1:
		for col in cols:
			var slot = slot_scene.instantiate()
			slot.slot_id = counter
			$Hotbar.add_child(slot)
			slots.append(slot)
			counter += 1
		
		for row in range(rows - 1):
			for col in range(cols):
				var slot = slot_scene.instantiate()
				slot.slot_id = counter
				$Full.add_child(slot)
				slots.append(slot)
				counter += 1
	
	var hint = hint_scene.instantiate()
	$Hotbar.add_child(hint)

func select(slot_index: int):
	slots[selected_slot].deselect()
	selected_slot = slot_index
	slots[selected_slot].select()

func _toggle_menu(state: bool):
	if state == true:
		open()
	else:
		close()
