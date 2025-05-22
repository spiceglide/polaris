extends ItemSlot

func _ready() -> void:
	$Sprite.modulate = Color(0.6, 0.6, 0.6)
	$Sprite.animation = anim
	clear_item()

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var source_id = data
	var dest_id = slot_id
	
	if source_id != dest_id:
		InventoryData.move_item(source_id, dest_id)
	
	$ItemSprite.visible = true
	update_timestamp()
