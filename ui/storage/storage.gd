extends Node
class_name Storage

var slots: Array[LogicalSlot]

func _init(size: int) -> void:
	slots.resize(size)
	for i in range(len(slots)):
		slots[i] = LogicalSlot.new()

func get_item(slot: int) -> GameItem:
	return slots[slot].item

func push(item: GameItem, quantity: int = 1, slots: Array[LogicalSlot] = self.slots) -> bool:
	var firstEmpty: LogicalSlot = null
	for slot in slots:
		if (not firstEmpty) and (not slot):
			firstEmpty = slot
		elif slot.item and slot.item.equals(item):
			while (quantity > 0) and (slot.quantity <= slot.item.max_stack):
				slot.quantity += 1
				quantity -= 1
	# Leftover items after stack fills up
	if quantity > 0:
		if firstEmpty:
			firstEmpty.item = item
			firstEmpty.quantity = quantity
		else:
			# TODO: drop remaining items
			return false
	
	return true

func pop(item: GameItem, quantity: int = 1, slots: Array[LogicalSlot] = self.slots) -> bool:
	slots.reverse()
	for slot in slots:
		if slot.item.equal(item):
			var lower = min(quantity, slot.quantity)
			quantity -= lower
			slot.quantity -= lower
	# Are we popping more items than the inventory contains?
	if quantity <= 0:
		return true
	return false

func swap(slotA: int, slotB: int) -> bool:
	var dataA := slots[slotA]
	slots[slotA] = slots[slotB]
	slots[slotB] = dataA
	return true

func clever_swap(slotA: int, slotB: int):
	if slots[slotA].item != slots[slotB].item:
		swap(slotA, slotB)
	else:
		var diff = slots[slotB].item.max_stack - slots[slotB].amount
		slots[slotB].amount += diff
		slots[slotA].amount -= diff

func shift(slot: int, dest: Array[LogicalSlot]):
	var data := slots[slot]
	slots[slot] = null
	push(data.item, data.quantity, dest)
