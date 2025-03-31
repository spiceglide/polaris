extends Camera2D

func _process(delta: float) -> void:
	_update_camera()

func _update_camera():
	var player_pos = PlayerData.position
	var scene_size = WorldData.scene_size
	var grid_size = WorldData.grid_size
	
	print(player_pos)
	print(scene_size)
	print()
	
	var bounds = [
		clamp(floor(player_pos.x / scene_size[0]),0, grid_size[0]-1) * scene_size[0],
		clamp(floor(player_pos.y / scene_size[1]), 0, grid_size[1]-1) * scene_size[1],
	]
		
	self.limit_left = bounds[0]
	self.limit_right = bounds[0] + scene_size[0]
	self.limit_top = bounds[1]
	self.limit_bottom = bounds[1] + scene_size[1]
