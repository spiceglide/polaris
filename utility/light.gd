extends PointLight2D

@export var light: float = 0.8

func _process(delta: float) -> void:
	var night_length = 0.1
	var gtime = reflect_around(WorldData.game_time/WorldData.day_length, 0.5)
	gtime = max(min(gtime / night_length, 1.0), 0.0)
	self.energy = light * (1.0-gtime)

func reflect_around(value: float, refl: float) -> float:
	return refl - abs(value - refl);
