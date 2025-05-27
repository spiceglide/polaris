extends CanvasModulate

func _process(delta: float) -> void:
	var night_length = 0.1
	var gtime = reflect_around(WorldData.game_time/WorldData.day_length, 0.5)
	gtime = max(min(gtime / night_length, 1.0), 0.0)
	self.color = Color(gtime, gtime, gtime)

func reflect_around(value: float, refl: float) -> float:
	return refl - abs(value - refl);
