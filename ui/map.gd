extends Node2D

@export var leak_opacity = 0.3
var available_scenes: Array = [
	[
		preload("res://scenes/tundra_river_e.tscn"),
		preload("res://scenes/forest_e_river_nw.tscn"),
		preload("res://scenes/forest_river_s.tscn"),
	], [
		preload("res://scenes/swamp_s_river_n.tscn"),
		preload("res://scenes/swamp_sw_forest_ne_river_w.tscn"),
		preload("res://scenes/forest_n_river_se.tscn"),
	], [
		preload("res://scenes/swamp_river_nw.tscn"),
		preload("res://scenes/swamp_w_tundra.tscn"),
		preload("res://scenes/tundra_river_e.tscn"),
	],
]

var scenes: Array = available_scenes
var current_scene = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene
	var instance
	
	var grid_size = WorldData.grid_size
	var scene_size = WorldData.scene_size
	
	for x in range(grid_size[0]):
		var temp_scenes = []
		for y in range(grid_size[1]):
			scene = available_scenes[y][x]
			
			instance = scene.instantiate()
			print(instance)
			
			instance.position.x = scene_size[0] * x
			instance.position.y = scene_size[1] * y
			#instance.visible = false
			instance.visible = true
			
			temp_scenes.append(instance)
			add_child(instance)
		scenes.append(temp_scenes)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_current_scene()
	#_cull_scenes()

func _cull_scenes():
	var grid_size = WorldData.grid_size
	
	for x in range(grid_size[0]):
		for y in range(grid_size[1]):
			var scene = scenes[y][x]
			scene.visible = false
			scene.modulate = Color(1, 1, 1, 1)
	
	var current = get_scene(current_scene)
	current.visible = true
	
	var adjacent = [
		#_north(current_scene), _east(current_scene),
		_south(current_scene), #_west(current_scene),
	]
	
	for adj in adjacent:
		if adj == null:
			continue
			
		adj.visible = true
		adj.modulate = Color(1, 1, 1, leak_opacity)

func _update_current_scene():
	var player_pos = PlayerData.position
	var grid_size = WorldData.grid_size
	var scene_size = WorldData.scene_size
	
	current_scene = [
		clamp(floor(player_pos[0] / scene_size[0]), 0, grid_size[0]-1),
		clamp(floor(player_pos[1] / scene_size[1]), 0, grid_size[1]-1),
	]

func _north(xy: Array):
	var i = xy[0]
	var j = xy[1] - 1
	
	if j < 0:
		return

	return scenes[i][j]

func _south(xy: Array):
	var grid_size = WorldData.grid_size
	var i = xy[0]
	var j = xy[1] + 1
	
	if j >= WorldData.grid_size[1]:
		return
	
	return scenes[i][j]


func _east(xy: Array):
	var i = xy[0] + 1
	var j = xy[1]
	
	if i >= WorldData.grid_size[0]:
		return
	
	return scenes[i][j]

func _west(xy: Array):
	var i = xy[0] - 1
	var j = xy[1]
	
	if i < 0:
		return
	
	return scenes[i][j]

func get_scene(xy: Array):
	return scenes[xy[0]][xy[1]]
