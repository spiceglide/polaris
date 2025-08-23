extends Node2D

signal interaction

@export var description: String
@export var item: String
@export var type: Interaction

enum Interaction {
	INSPECT,
	PICKUP,
	DISPOSE,
	PICKUP_AND_DISPOSE,
	OTHER,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("interactive")

func interact(player):
	var announcer = player.get_node("Announcement")
	
	match type:
		Interaction.INSPECT:
			announcer.announce(description)
		Interaction.PICKUP:
			if not item:
				return
			if InventoryData.set_item_at_first_empty(item):
				announcer.announce(item, "system")
		Interaction.DISPOSE:
			announcer.announce(description)
			self.get_parent().queue_free()
		Interaction.PICKUP_AND_DISPOSE:
			if not item:
				return
			
			if InventoryData.set_item_at_first_empty(item):
				announcer.announce(item, "system")
				self.get_parent().queue_free()
			else:
				announcer.announce("Inventory full!")
		Interaction.OTHER:
			interaction.emit()
			
