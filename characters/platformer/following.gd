extends Node2D

@export var speed: float = 5.0
@export var distance: float = 20.0

func _process(delta: float) -> void:
	sync_items()
	follow(delta)

func follow(delta: float) -> void:
	var counter = 1
	var dest = self.global_position
	
	for follower in self.get_children():
		if follower.global_position.distance_to(dest) > distance:
			follower.global_position = follower.global_position.lerp(dest, speed * delta)
		dest = follower.global_position
		counter += 1

func sync_items() -> void:
	var counter = {}
	var to_delete = []
	
	# Set counter
	for key in InventoryData.collectables.keys():
		counter[key] = 0
	
	# Count followers
	for follower in self.get_children():
		var type = follower.type
		counter[type] += 1
		
		# Mark excess items
		if counter[type] > InventoryData.collectables[type]:
			to_delete.append(follower)
	
	# Delete excess items
	for follower in to_delete:
		follower.queue_free()
