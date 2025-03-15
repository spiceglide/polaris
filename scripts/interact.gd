extends Area2D

@onready var inventory: InventorySystem = HUD.get_node("Inventory")

@export var description: String
@export var item: String
@export var type: Interaction

enum Interaction {
	INSPECT,
	PICKUP,
	PICKUP_AND_DISPOSE,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	match type:
		Interaction.INSPECT:
			HUD.announcement = description
		Interaction.PICKUP:
			HUD.announcement = description
			inventory.set_item(item)
		Interaction.PICKUP_AND_DISPOSE:
			HUD.announcement = description
			inventory.set_item(item)
			self.get_parent().queue_free()
