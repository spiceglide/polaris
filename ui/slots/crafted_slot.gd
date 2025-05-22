extends ItemSlot

var enabled = false

func _process(delta: float) -> void:
	if state == SlotState.SELECTED_CLICK:
		quick_move()
		state = SlotState.INACTIVE
	
func enable():
	enabled = true
	$Sprite.modulate = Color(1, 1, 1)

func disable():
	enabled = false
	$Sprite.modulate = Color(0.6, 0.6, 0.6)

func quick_move():
	get_tree().call_group("crafting", "craft_complete", item.item_id)
	InventoryData.set_item_at_first_empty(item.item_id)

func _get_drag_data(at_position: Vector2) -> Variant:
	quick_move()
	return
