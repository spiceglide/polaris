extends Node

var active_scene = null
var rooms = null
var scenes := {
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

	if first_time:
		PlayerData.reset()
	else:
		PlayerData.health = 100
	
	var loading = scenes["loading_screen"]
	get_tree().change_scene_to_file(loading)
	get_tree().paused = false
	
	active_scene = scenes["main_game"]
	ResourceLoader.load_threaded_request(active_scene)
	$Timer.start(1)

func load_dream_game() -> void:
	WorldData.game_mode = WorldData.GameMode.Dream
	PlayerData.health = 100
	
	var loading = scenes["loading_screen"]
	get_tree().change_scene_to_file(loading)
	get_tree().paused = false

	active_scene = scenes["dream_game"]
	ResourceLoader.load_threaded_request(active_scene)
	$Timer.start(1)

func switch_room(new_room: String):
	if len(rooms) <= 0:
		print("No rooms loaded")
		return
	
	"""
	var room_names = rooms.map(func (x): x.name)
	print(rooms)
	print(room_names)
	print(new_room)
	
	if new_room not in room_names:  # only the names PLEASE
		print("Room '" + new_room + "' not found")
		return
	"""
	
	for room in rooms:
		if room.name == new_room:
			room.process_mode = PROCESS_MODE_INHERIT
			room.visible = true
			
			var camera: Camera2D = room.get_node_or_null("Camera2D")
			if camera:
				camera.enabled = true
				camera.make_current()
		else:
			room.visible = false
			room.process_mode = PROCESS_MODE_DISABLED

func _on_timer_timeout() -> void:
	if ResourceLoader.load_threaded_get_status(active_scene) == 3:
		var scene = ResourceLoader.load_threaded_get(active_scene)
		get_tree().change_scene_to_packed(scene)
		$Timer.stop()
	else:
		$Timer.start(0.5)
