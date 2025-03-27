extends Camera2D

@onready var player = self.get_parent()

const DIMS = 24*160
var grid_size = [3, 2]
var scene_size = [DIMS, DIMS]

func _process(delta: float) -> void:
	_update_camera()

func _update_camera():
	var player_pos = player.position
	
	var bounds = [
		clamp(floor(player_pos.x / scene_size[0]), 0, grid_size[0]-1) * scene_size[0],
		clamp(floor(player_pos.y / scene_size[1]), 0, grid_size[1]-1) * scene_size[1],
	]
		
	self.limit_left = bounds[0]
	self.limit_right = bounds[0] + scene_size[0]
	self.limit_top = bounds[1]
	self.limit_bottom = bounds[1] + scene_size[1]
