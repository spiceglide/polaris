extends Node2D

enum GameMode {
	Overworld,
	Dream,
}

const DIMS = 24*160
var grid_size = [4, 3]
var scene_size = [DIMS, DIMS]
var current_scene = null
var game_mode = GameMode.Dream

@export var day_length: int = 60*10
var game_time: float = day_length / 2.0
var current_biome: String = "tundra"

func _ready() -> void:
	if game_mode == GameMode.Dream:
		HUD.get_node("DayNight").visible = false
		HUD.get_node("Vignette").visible = false

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

func get_game_mode() -> String:
	match game_mode:
		GameMode.Overworld:
			return "overworld"
		GameMode.Dream:
			return "dream"
	return ""
