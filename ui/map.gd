extends Node2D

const DIMS = 24*640
const RENDER_DISTANCE = 1

@export var grid_size = [9, 9]
@export var leak_opacity = 0.3
var scene_size = [DIMS, DIMS]
var available_scenes = [preload("res://screens/Level_Snow_1.tscn")]
var scenes = []
var current_scene = 0

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
	_update_current_scene()
	_cull_scenes()

func _cull_scenes():
	for x in range(grid_size[0]):
		for y in range(grid_size[1]):
			var scene = scenes[x][y]
			scene.visible = false
			scene.modulate = Color(1, 1, 1, 1)
	
	var current = get_scene(current_scene)
	current.visible = true
	
	var adjacent = [
		_north(current_scene), _east(current_scene),
		_south(current_scene), _west(current_scene),
	]
	
	for adj in adjacent:
		if adj == null:
			continue
			
		adj.visible = true
		adj.modulate = Color(1, 1, 1, leak_opacity)

func _update_current_scene():
	var player_pos = HUD.get_meta("player_pos")
	current_scene = [
		clamp(floor(player_pos[0] / scene_size[0]), 0, grid_size[0]),
		clamp(floor(player_pos[1] / scene_size[1]), 0, grid_size[1]),
	]

func _north(xy: Array):
	var i = xy[0] - 1
	var j = xy[1]
	
	if i < 0:
		return

	return scenes[i][j]

func _south(xy: Array):
	var i = xy[0] + 1
	var j = xy[1]
	
	if i > grid_size[0]:
		return
	
	return scenes[i][j]


func _east(xy: Array):
	var i = xy[0]
	var j = xy[1] + 1
	
	if j > grid_size[1]:
		return
	
	return scenes[i][j]

func _west(xy: Array):
	var i = xy[0]
	var j = xy[1] - 1
	
	if j < 0:
		return
	
	return scenes[i][j]

func get_scene(xy: Array):
	return scenes[xy[0]][xy[1]]
