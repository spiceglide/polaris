extends Node2D

@export var type: String

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not InventoryData.collectables.has(type):
		InventoryData.collectables[type] = 0
	
	InventoryData.collectables[type] += 1
	queue_free()
