extends Node2D

func _ready():
	pass

func _process(delta: float) -> void:
	if WorldData.game_time < WorldData.day_length:
		WorldData.game_time += delta
	
	RenderingServer.global_shader_parameter_set("game_time", WorldData.game_time/WorldData.day_length * 360)
