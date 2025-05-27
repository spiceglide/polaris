extends Node2D

const DIMS = 24*160
var grid_size = [3, 2]
var scene_size = [DIMS, DIMS]
var current_scene = null

@export var day_length: int = 60*10
var game_time: float = day_length / 2.0
var current_biome: String = "tundra"

func new_day():
	game_time = 0

func is_night() -> bool:
	return game_time >= day_length

func how_far_in_day() -> float:
	return game_time / day_length

func get_random_point(rect: Vector2) -> Vector2:
	var x = randi() % int(rect.x)
	var y = randi() % int(rect.y)
	return Vector2(x, y)
