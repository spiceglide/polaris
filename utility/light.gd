extends PointLight2D

@export var light: float = 0.8
@export var jitter_radius: float = 10.0
@export var jitter_speed: float = 2.0
var jitter_angle: float = 0.0

func _process(delta: float) -> void:
	set_brightness()
	if self.visible:
		process_jitter()

func process_jitter() -> void:
	jitter_angle += jitter_speed * get_process_delta_time()
	self.position.x = jitter_radius * cos(jitter_angle)
	self.position.y = jitter_radius * sin(jitter_angle)

func set_brightness() -> void:
	var night_length = 0.1
	var gtime = reflect_around(WorldData.game_time/WorldData.day_length, 0.5)
	gtime = max(min(gtime / night_length, 1.0), 0.0)
	self.energy = light * (1.0-gtime)

func reflect_around(value: float, refl: float) -> float:
	return refl - abs(value - refl);
