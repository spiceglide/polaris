extends Node

func _ready():
	pass

func _process(delta: float) -> void:
	if WorldData.get_game_mode() == "dream":
		return
	
	if WorldData.game_time < WorldData.day_length:
		WorldData.game_time += delta
	
	RenderingServer.global_shader_parameter_set("game_time", (WorldData.game_time/WorldData.day_length) * 360)
