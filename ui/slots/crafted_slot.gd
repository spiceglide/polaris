extends ItemSlot

var enabled := false
var inputs: Array[GameItem] = []

func _process(delta: float) -> void:
	if state == SlotState.SELECTED_CLICK:
		quick_move()
		state = SlotState.INACTIVE

func set_inputs(items: Array[GameItem]):
	inputs = items

func enable():
	enabled = true
	$Sprite.modulate = Color(1, 1, 1)

func disable():
	enabled = false
	$Sprite.modulate = Color(0.6, 0.6, 0.6)

func quick_move():
	if enabled:
		get_tree().call_group("crafting", "craft_complete", item, inputs)

func _get_drag_data(at_position: Vector2) -> Variant:
	quick_move()
	return
