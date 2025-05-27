extends PointLight2D

@export var light: float = 0.8

func _process(delta: float) -> void:
	var gtime = 1.0 - (abs(WorldData.game_time - 60/2) / 30.0)
	var normtime = min(gtime*10, 1.0)
	self.energy = light * (1.0-gtime)
