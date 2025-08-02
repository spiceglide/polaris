extends Node2D

var active_scene = null
var scenes = {
	"main_menu": "res://screens/MainMenu.tscn",
	"loading_screen": "res://screens/LoadingScreen.tscn",
	"main_game": "res://screens/MainGame.tscn",
	"dream_game": "res://screens/DreamGame.tscn",
}

func load_main_menu() -> void:
	var next = scenes["main_menu"]
	get_tree().change_scene_to_file(next)
	get_tree().paused = false

	active_scene = "main_menu"

func load_main_game(first_time: bool = false) -> void:
	WorldData.game_mode = WorldData.GameMode.Overworld
	HUD.get_node("DayNight").visible = true
	HUD.get_node("Vignette").visible = true
	HUD.get_node("StatsLeft").reset()
	HUD.get_node("StatsRight").reset()
	
	var loading = scenes["loading_screen"]
	get_tree().change_scene_to_file(loading)
	get_tree().paused = false

	active_scene = scenes["main_game"]
	ResourceLoader.load_threaded_request(active_scene)
	$Timer.start(1)

func load_dream_game() -> void:
	WorldData.game_mode = WorldData.GameMode.Dream
	HUD.get_node("DayNight").visible = false
	HUD.get_node("Vignette").visible = false
	HUD.get_node("StatsLeft").reset()
	HUD.get_node("StatsRight").reset()
	
	var loading = scenes["loading_screen"]
	get_tree().change_scene_to_file(loading)
	get_tree().paused = false

	active_scene = scenes["dream_game"]
	ResourceLoader.load_threaded_request(active_scene)
	$Timer.start(1)

func _on_timer_timeout() -> void:
	if ResourceLoader.load_threaded_get_status(active_scene) == 3:
		var scene = ResourceLoader.load_threaded_get(active_scene)
		get_tree().change_scene_to_packed(scene)
		$Timer.stop()
	else:
		$Timer.start(1)
