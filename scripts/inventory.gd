extends Node2D
class_name InventorySystem

var slot_scene = preload("res://scenes/slot.tscn")

@export var cols: int = 5
@export var rows: int = 5
var slots: Array[InventorySlot] = []
var anims: Array[String] = ["type1", "type2", "type3", "type4", "type5"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_err = self.connect("item_pick_up",self,"item_pick_up")
	$Full.columns = cols
	if rows >= 1:
		for col in cols:
			var slot = slot_scene.instantiate()
			slot.anim = anims[col % len(anims)]
			slots.append(slot)
			$Hotbar.add_child(slot)
		
		$Full.columns = cols
		for row in range(rows - 1):
			for col in range(cols):
				var slot = slot_scene.instantiate()
				slot.anim = anims[col % len(anims)]
				slots.append(slot)
				$Full.add_child(slot)
	
	var hint = slot_scene.instantiate()
	hint.anim = "hint"
	$Hotbar.add_child(hint)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if Input.is_action_just_pressed("inventory"):
		$Full.visible = !($Full.visible)
