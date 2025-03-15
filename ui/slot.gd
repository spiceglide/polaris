extends Control
class_name InventorySlot

@export var item: Item
@export var anim: String = "type1"

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
	var preview = self.duplicate()
	preview.modulate = 1
	set_drag_preview(preview)
	return [item, self]

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if item:
		return false
	if not data[0]:
		return false
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	print("dropping_data")
	print(data)
	set_item(data[0].item_id)
	data[1].clear_item()
