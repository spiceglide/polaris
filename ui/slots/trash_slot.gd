extends ItemSlot

func _ready() -> void:
	$Sprite.modulate = Color(0.6, 0.6, 0.6)
	$Sprite.animation = anim
	clear_item()

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var source_item = data["item"]
	var source_id = data["id"]
	var dest_id = slot_id
	
	if source_id != dest_id:
		var amount := InventoryData.inventory.slots[source_id].quantity
		InventoryData.trash.clear()
		InventoryData.trash.push(source_item, amount)
		InventoryData.inventory.slots[source_id].pop(source_item, amount)
	
	$ItemSprite.visible = true
	update_timestamp()
