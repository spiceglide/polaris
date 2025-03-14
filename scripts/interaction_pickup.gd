extends Area2D

@onready var inventory: InventorySystem = HUD.get_node("Inventory")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	#emit_signal("itemPickUp", item_id)
	inventory.set_item("rock")
	HUD.announcement = '"Better than nothing"'
	self.get_parent().queue_free()
