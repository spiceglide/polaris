extends Node

@onready var size = 5*5

var slots: Array[String]
var selected_slot: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots.resize(size)
	select_slot(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_item(slot: int, item: String) -> bool:
	if not slots[slot]:
		slots[slot] = item
		return true
	return false

func set_item_at_first_empty(item: String) -> bool:
	return set_item(get_first_empty_slot(), item)
	
func set_item_at_selected(item: String) -> bool:
	return set_item(selected_slot, item)

func get_first_empty_slot():
	for i in range(len(slots)):
		if not slots[i]:
			return i

func get_item(index: int):
	return slots[index]

func get_all_items():
	return slots.filter(
		func(item): return bool(item)
	)

func select_slot(index: int):
	selected_slot = index

func clear_slot(index: int):
	slots[index] = ""
