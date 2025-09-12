extends Control
class_name ItemSlot

enum SlotState {
	INACTIVE,
	SELECTED_DRAG,
	SELECTED_CLICK,
}

@export var anim: String = "type1"
var item: String = ""
var state = SlotState.INACTIVE
var last_used = Time.get_ticks_msec()
var slot_id: int = -1
var selected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.animation = anim
	clear_item()
	add_to_group("inventory_slots")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == SlotState.SELECTED_CLICK:
		_clickdrag()
	
func set_item(id: String):
	item = id
	self.tooltip_text = tr("ITEM_" + id.to_upper() + "_NAME")
	
	if $ItemSprite.sprite_frames.has_animation(id):
		$ItemSprite.animation = id
	else:
		$ItemSprite.animation = "default"
	$ItemSprite.visible = true
	
func clear_item():
	item = ""
	self.tooltip_text = ""

	$ItemSprite.visible = false
	update_timestamp()

func get_item() -> String:
	return item

func select():
	self.selected = true
	self.scale = Vector2(0.95, 0.95)
	$Sprite.modulate = Color(0.85, 0.85, 0.85)
	
func deselect():
	self.selected = false
	self.scale = Vector2(1, 1)
	$Sprite.modulate = Color(1, 1, 1)

func update_timestamp():
	last_used = Time.get_ticks_msec()

func _clickdrag():
	if not item:
		return
	
	$ItemSprite.visible = false
	var drag_data = _generate_drag_data()
	force_drag(drag_data["slot"], drag_data["preview"])

func _get_drag_data(at_position: Vector2) -> Variant:
	if not item:
		return
	
	$ItemSprite.visible = false
	state = SlotState.SELECTED_CLICK
	
	var drag_data = _generate_drag_data()
	set_drag_preview(drag_data["preview"])
	return drag_data["slot"]

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var slot_id = data["id"]
	return (InventoryData.get_item(slot_id) != null)

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var source_id = data["id"]
	var dest_id = slot_id
	
	if source_id != dest_id:
		InventoryData.swap_items(source_id, dest_id)
	
	$ItemSprite.visible = true
	update_timestamp()
	
func _generate_preview():
	var preview = TextureRect.new()
	var spriteName = $ItemSprite.get_animation()
	var frame = $ItemSprite.sprite_frames.get_frame_texture($ItemSprite.get_animation(), 0)
	preview.texture = frame
	preview.z_index = 1
	return preview

func _generate_drag_data():
	return {
		"slot": { "id": slot_id, "item": item, },
		"preview": _generate_preview(),
	}

func quick_move():
	var start = 5 if slot_id < 5 else 0
	InventoryData.move_item_to_first_empty(slot_id, start)

func _notification(type):
	match type:
		NOTIFICATION_DRAG_END:
			if state == SlotState.INACTIVE:
				return
			state = SlotState.INACTIVE
			update_timestamp()
			$ItemSprite.visible = true

func _on_button_pressed() -> void:
	if state == SlotState.INACTIVE:
		var timestamp = Time.get_ticks_msec()
		if (timestamp - last_used) < 200:
			return
		if item:
			if Input.is_action_pressed("quick_move"):
				quick_move()
			else:
				state = SlotState.SELECTED_CLICK
