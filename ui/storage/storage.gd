extends Node
class_name Storage

var slots: Array[LogicalSlot]

func _init(size: int) -> void:
	slots.resize(size)
	for i in range(len(slots)):
		slots[i] = LogicalSlot.new(i)

func get_item(slot: int) -> GameItem:
	return slots[slot].item

func push(item: GameItem, quantity: int = 1, slots: Array[LogicalSlot] = self.slots) -> bool:
	var firstEmpty: LogicalSlot = null
	for slot in slots:
		if (not firstEmpty) and (not slot.item):
			firstEmpty = slot
		elif slot.item and slot.item.equals(item):
			while (quantity > 0) and (slot.quantity < slot.item.max_stack):
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
		if slot.item and slot.item.equals(item):
			var lower = min(quantity, slot.quantity)
			quantity -= lower
			slot.quantity -= lower
			
			if slot.quantity == 0:
				slot.item = null
	# Are we popping more items than the inventory contains?
	if quantity <= 0:
		return true
	return false

func swap(slotA: int, slotB: int, slotsA: Array[LogicalSlot] = self.slots, slotsB: Array[LogicalSlot] = self.slots) -> bool:
	var dataA := slotsA[slotA]
	slotsA[slotA] = slotsB[slotB]
	slotsB[slotB] = dataA
	return true

func clever_swap(slotA: int, slotB: int, slotsA: Array[LogicalSlot] = self.slots, slotsB: Array[LogicalSlot] = self.slots) -> bool:
	if slotsA[slotA].item != slotsB[slotB].item:
		swap(slotA, slotB, slotsA, slotsB)
	else:
		var diff = slotsB[slotB].item.max_stack - slotsB[slotB].amount
		slotsB[slotB].amount += diff
		slotsA[slotA].amount -= diff
	return true

func shift(slot: int, dest: Array[LogicalSlot]):
	var item := slots[slot].item
	var quantity := slots[slot].quantity
	slots[slot].clear()
	push(item, quantity, dest)
