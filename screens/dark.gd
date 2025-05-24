extends CanvasModulate

func _process(delta: float) -> void:
	var gtime = 1.0 - (abs(WorldData.game_time - 60/2) / 30.0)
	var normtime = min(gtime*10, 1.0)
	self.color = Color(gtime, gtime, gtime)
