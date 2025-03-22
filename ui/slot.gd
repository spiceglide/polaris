extends Control
class_name InventorySlot

enum SlotState {
	INACTIVE,
	SELECTED_DRAG,
	SELECTED_CLICK,
}

@export var item: Item
@export var anim: String = "type1"
var state = SlotState.INACTIVE
var last_used = Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.animation = anim
	$Sprite.play()
	$ItemSprite.play()
	$ItemSprite.visible = false
	
	add_to_group("inventory_slots")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if state == SlotState.SELECTED_CLICK:
			$ItemSprite.visible = false
			force_drag([item, self], _generate_preview())
	
func set_item(id: String):
	$Item.set_item(id)
	item = $Item
	
	$ItemSprite.animation = id
	$ItemSprite.visible = true
	
func clear_item():
	item = null
	$ItemSprite.visible = false

func get_item():
	if item:
		return $Item.item_id

func select():
	self.scale = Vector2(0.95, 0.95)
	$Sprite.modulate = Color(0.85, 0.85, 0.85)
	
func deselect():
	self.scale = Vector2(1, 1)
	$Sprite.modulate = Color(1, 1, 1)

func _get_drag_data(at_position: Vector2) -> Variant:
	if not item:
		return
	
	if state == SlotState.INACTIVE:
		state = SlotState.SELECTED_DRAG
		
	var preview = _generate_preview()
	set_drag_preview(preview)
	$ItemSprite.visible = false
	return [item, self]

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if item:
		return false
	if not data[0]:
		return false
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	set_item(data[0].item_id)
	last_used = Time.get_ticks_msec()
	
func _generate_preview():
	var preview = TextureRect.new()
	var spriteName = $ItemSprite.get_animation()
	var frame = $ItemSprite.sprite_frames.get_frame_texture($ItemSprite.get_animation(), 0)
	preview.texture = frame
	preview.z_index = 1
	preview.scale = Vector2(0.3, 0.3)
	return preview

func _notification(type):
	match type:
		NOTIFICATION_DRAG_END:
			if state == SlotState.INACTIVE:
				return
			state = SlotState.INACTIVE
			last_used = Time.get_ticks_msec()
			
			if is_drag_successful():
				clear_item()
			else:
				if item:
					$ItemSprite.visible = true

func _on_button_pressed() -> void:
	if state == SlotState.INACTIVE:
		var timestamp = Time.get_ticks_msec()
		if (timestamp - last_used) < 200:
			return
		if item:
			state = SlotState.SELECTED_CLICK
