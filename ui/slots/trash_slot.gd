extends InventorySlot

func _ready() -> void:
	$Sprite.modulate = Color(0.6, 0.6, 0.6)
	$Sprite.animation = anim
	clear_item()

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var source_slot = data[1]
	source_slot.clear_item()
	set_item(data[0].item_id)
	state = SlotState.INACTIVE
	last_used = Time.get_ticks_msec()
