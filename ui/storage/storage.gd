extends Node
class_name Storage

@export var size: int = 5*5

var slots: Array[LogicalSlot] = []

func _init(size: int) -> void:
	self.size = size

func push(item: GameItem, quantity: int = 1, slots: Array[LogicalSlot] = self.slots) -> bool:
	var firstEmpty: LogicalSlot = null
	for slot in slots:
		if not firstEmpty and slot.is_empty():
			firstEmpty = slot
		elif slot.item.equals(item):
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
