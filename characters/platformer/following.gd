extends Node2D

@export var speed: float = 5.0
@export var distance: float = 20.0

func _process(delta: float) -> void:
	var counter = 1
	var dest = self.global_position
	
	for follower in self.get_children():
		if follower.global_position.distance_to(dest) > distance:
			follower.global_position = follower.global_position.lerp(dest, speed * delta)
		dest = follower.global_position
		counter += 1
