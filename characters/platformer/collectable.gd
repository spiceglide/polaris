extends Node2D

@export var type: String
@export var follower: bool = false
@export var can_collect: bool = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not can_collect:
		return
	
	if body.name != "Player":
		return
	
	if not InventoryData.collectables.has(type):
		InventoryData.collectables[type] = 0
	
	InventoryData.collectables[type] += 1
	
	if follower:
		can_collect = false
		self.top_level = true
		
		var following_node = body.get_node("Following")
		get_parent().remove_child(self)
		following_node.add_child(self)
	else:
		queue_free()
