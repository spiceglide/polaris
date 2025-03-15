extends Node2D

const DIMS = 24*640
const RENDER_DISTANCE = 2

@export var grid_size = [9, 9]
var scene_size = [DIMS, DIMS]
#var scenes = [preload("res://scenes/scene1.tscn"), preload("res://scenes/scene2.tscn"), preload("res://scenes/scene3.tscn")]
var available_scenes = [preload("res://screens/Level_Snow_1.tscn")]
var scenes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene
	var instance
	
	for x in range(grid_size[0]):
		var temp_scenes = []
		for y in range(grid_size[1]):
			scene = available_scenes.pick_random()
			instance = scene.instantiate()
			
			instance.position.x = scene_size[0] * x
			instance.position.y = scene_size[1] * y
			instance.visible = false
			
			temp_scenes.append(instance)
			add_child(instance)
		scenes.append(temp_scenes)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_cull_scenes()

func _cull_scenes():
	var player_pos = Player.position
	var bounds = [
		Player.position.x - (RENDER_DISTANCE * DIMS),
		Player.position.x + (RENDER_DISTANCE * DIMS),
		Player.position.y - (RENDER_DISTANCE * DIMS),
		Player.position.y + (RENDER_DISTANCE * DIMS),
	]
	
	var printthing = ""
	for x in range(grid_size[0]):
		for y in range(grid_size[1]):
			if (x*DIMS < bounds[0]) or (x*DIMS > bounds[1] or (y*DIMS < bounds[2]) or (y*DIMS > bounds[3])):
				scenes[x][y].visible = false
			else:
				scenes[x][y].visible = true
			
			printthing += ('O' if scenes[x][y].visible else 'X')
		printthing += "\n"
	print(printthing)
	print()
