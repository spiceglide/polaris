extends Control
class_name ItemSlot

var item_scene = preload("res://ui/Item.tscn")

enum SlotState {
	INACTIVE,
	SELECTED_DRAG,
	SELECTED_CLICK,
}

@export var item: Item = null
@export var anim: String = "type1"
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
	item = item_scene.instantiate()
	item.set_item(id)
	
	$ItemSprite.animation = id
	$ItemSprite.visible = true
	
func clear_item():
	item = null
	$ItemSprite.visible = false
	update_timestamp()

func get_item():
	if item:
		return item.item_id

func select():
	self.selected = true
	self.scale = Vector2(0.95, 0.95)
	$Sprite.modulate = Color(0.85, 0.85, 0.85)
	
func deselect():
	self.selected = false
	self.scale = Vector2(1, 1)
	$Sprite.modulate = Color(1, 1, 1)

func use():
	if item:
		var consumed = item.use()
		if consumed:
			clear_item()

func quick_move():
	var slot = InventoryData.get_first_empty_slot()
	InventoryData.set_item(slot, item.item_id)
	self.clear_item()

func update_timestamp():
	last_used = Time.get_ticks_msec()

func _clickdrag():
	if not item:
		return
	
	$ItemSprite.visible = false
	var drag_data = _generate_drag_data()
	force_drag(drag_data["data"], drag_data["preview"])

func _get_drag_data(at_position: Vector2) -> Variant:
	if not item:
		return
	
	if state == SlotState.INACTIVE:
		state = SlotState.SELECTED_DRAG
	
	$ItemSprite.visible = false
		
	var drag_data = _generate_drag_data()
	set_drag_preview(drag_data["preview"])
	return drag_data["data"]

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not data[0]:
		return false
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var source_slot = data[1]
	if item:
		source_slot.set_item(item.item_id)
	else:
		source_slot.clear_item()
	set_item(data[0].item_id)
	state = SlotState.INACTIVE
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
		"data": [item.duplicate(), self],
		"preview": _generate_preview(),
	}

func _notification(type):
	match type:
		NOTIFICATION_DRAG_END:
			if state == SlotState.INACTIVE:
				return
			state = SlotState.INACTIVE
			update_timestamp()
			
			if is_drag_successful():
				pass
			else:
				if item:
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
