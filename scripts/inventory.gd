extends Control
class_name InventorySystem

@onready var slot_scene = preload("res://scenes/slot.tscn")
@onready var item_scene = preload("res://scenes/item.tscn")

@export var cols: int = 5
@export var rows: int = 5
var slots: Array[InventorySlot] = []
var anims: Array[String] = ["type1", "type2", "type3", "type4", "type5"]
var selected_slot: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_err = self.connect("item_pick_up",self,"item_pick_up")
	$Full.columns = cols
	
	if rows >= 1:
		for col in cols:
			var slot = slot_scene.instantiate()
			slot.anim = anims[col % len(anims)]
			$Hotbar.add_child(slot)
			slots.append(slot)
		
		for row in range(rows - 1):
			for col in range(cols):
				var slot = slot_scene.instantiate()
				slot.anim = anims[col % len(anims)]
				$Full.add_child(slot)
				slots.append(slot)
	
	var hint = slot_scene.instantiate()
	hint.anim = "hint"
	$Hotbar.add_child(hint)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("inventory"):
		$Full.visible = !($Full.visible)
		
	if event.is_action_pressed("hotbar"):
		selected_slot = event.as_text().to_int() - 1
		
	if event.is_action_pressed("drop"):
		slots[selected_slot].clear_item()

func set_item(item_id: String) -> bool:
	var slot = slots[selected_slot]
	if slot.item == null:
		slot.set_item(item_id)
		print("Picked up '" + item_id + "'")
		return true
	else:
		return false
