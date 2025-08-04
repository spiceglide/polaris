extends PointLight2D

@export var light: float = 0.8
@export var jitter_strength: int = 2
var jitter_direction: float = 1.0

func _process(delta: float) -> void:
	set_brightness()
	if self.visible:
		process_jitter()

func process_jitter() -> void:
	self.rotation_degrees += jitter_direction
	if abs(self.rotation_degrees) > jitter_strength:
		jitter_direction *= -1

func set_brightness() -> void:
	var night_length = 0.1
	var gtime = reflect_around(WorldData.game_time/WorldData.day_length, 0.5)
	gtime = max(min(gtime / night_length, 1.0), 0.0)
	self.energy = light * (1.0-gtime)

func reflect_around(value: float, refl: float) -> float:
	return refl - abs(value - refl);
