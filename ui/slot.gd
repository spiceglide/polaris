extends Control
class_name InventorySlot

@export var item: Item
@export var anim: String = "type1"
var is_dragging: bool = false

signal slot_click(which: InventorySlot)
signal slot_hovered(which: InventorySlot, is_hover: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.animation = anim
	$Sprite.play()
	$ItemSprite.play()
	$ItemSprite.visible = false
	add_to_group("inventory_slots")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
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

func _get_drag_data(at_position: Vector2) -> Variant:
	var preview = TextureRect.new()
	var spriteName = $ItemSprite.get_animation()
	var frame = $ItemSprite.sprite_frames.get_frame_texture($ItemSprite.get_animation(), 0)
	preview.texture = frame
	preview.scale = Vector2(0.3, 0.3)
	set_drag_preview(preview)
	
	is_dragging = true
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
	#data[1].clear_item()

func _notification(type):
	match type:
		NOTIFICATION_DRAG_END:
			if not is_dragging:
				return
			is_dragging = false
			
			if is_drag_successful():
				clear_item()
			else:
				$ItemSprite.visible = true
