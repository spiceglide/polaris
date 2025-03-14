extends Control
class_name InventorySlot

@export var item: Item

signal slot_click(which: InventorySlot)
signal slot_hovered(which: InventorySlot, is_hover: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("inventory_slots")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		slot_click.emit(self)

func _on_button_mouse_entered() -> void:
	slot_hovered.emit(self, true)

func _on_button_mouse_exited() -> void:
	slot_hovered.emit(self, false)
