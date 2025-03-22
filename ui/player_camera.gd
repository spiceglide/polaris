extends Camera2D

@onready var player = self.get_parent()

const DIMS = [24*640, 24*640]
var grid_size = [9, 9]
var scene_size = [DIMS, DIMS]

func _process(delta: float) -> void:
	_update_camera()

func _update_camera():
	var player_pos = player.position
	
	var bounds = [
		floor(player_pos.x - (int(player_pos.x) % DIMS[0])),
		floor(player_pos.y - (int(player_pos.y) % DIMS[1])),
	]
		
	self.limit_left = bounds[0]
	self.limit_right = bounds[0] + DIMS[0]
	self.limit_top = bounds[1]
	self.limit_bottom = bounds[1] + DIMS[1]
