extends Node2D

@export var day_length: int = 60 #900
var game_time = 0;

func _ready():
	pass

func _process(delta: float) -> void:
	if game_time < day_length:
		game_time += delta
	
	RenderingServer.global_shader_parameter_set("game_time", game_time/day_length * 360)
