extends Node
class_name LogicalSlot

var item: GameItem = null
var quantity: int = 0

func push(item: GameItem, quantity: int = 1) -> bool:
	if is_empty():
		self.item = item
		self.quantity = quantity
		return true
	if item == self.item:
		self.quantity = min(item.max_stack, self.quantity + quantity)
		return true
	return false

func pop(item: GameItem, quantity: int = 1) -> bool:
	if is_empty():
		return false
	if item == self.item:
		self.quantity = max(0, self.quantity - quantity)
		return true
	return true

func clear():
	item = null
	quantity = 0

func is_empty() -> bool:
	return (not item) or (quantity <= 0)
