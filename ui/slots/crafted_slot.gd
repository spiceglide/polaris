extends ItemSlot

var enabled = false
	
func enable():
	enabled = true
	$Sprite.modulate = Color(1, 1, 1)

func disable():
	enabled = false
	$Sprite.modulate = Color(0.6, 0.6, 0.6)

func _clickdrag():
	if not enabled:
		return
	if not item:
		return
	
	$ItemSprite.visible = false
	var drag_data = _generate_drag_data()
	force_drag(drag_data["data"], drag_data["preview"])

func _get_drag_data(at_position: Vector2) -> Variant:
	if not enabled:
		return
	if not item:
		return
	
	if state == SlotState.INACTIVE:
		state = SlotState.SELECTED_DRAG
	
	$ItemSprite.visible = false
		
	var drag_data = _generate_drag_data()
	set_drag_preview(drag_data["preview"])
	return drag_data["data"]

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return false
