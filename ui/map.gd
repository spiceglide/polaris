extends Node2D

var available_scenes: Array = [
	[
		preload("res://scenes/tundra_river_e.tscn").instantiate(),
		preload("res://scenes/forest_e_river_nw.tscn").instantiate(),
		preload("res://scenes/forest_river_s.tscn").instantiate(),
		preload("res://scenes/tundra_river_e2.tscn").instantiate(),
	], [
		preload("res://scenes/swamp_s_river_n.tscn").instantiate(),
		preload("res://scenes/swamp_sw_forest_ne_river_w.tscn").instantiate(),
		preload("res://scenes/forest_n_river_se.tscn").instantiate(),
		preload("res://scenes/tundra_river_e2.tscn").instantiate(),
	], [
		preload("res://scenes/swamp_river_nw.tscn").instantiate(),
		preload("res://scenes/swamp_w_tundra.tscn").instantiate(),
		preload("res://scenes/tundra_river_e.tscn").instantiate(),
		preload("res://scenes/tundra_river_e2.tscn").instantiate(),
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
			instance = scene
			print(instance)
			
			instance.position.x = scene_size[0] * x
			instance.position.y = scene_size[1] * y
			#instance.visible = false
			instance.visible = true
			
			temp_scenes.append(instance)
			add_child(instance)
		scenes.append(temp_scenes)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_update_current_scene()
	WorldData.current_biome = get_current_biome()
	_cull_scenes()

func _cull_scenes():
	var grid_size = WorldData.grid_size
	
	for x in range(grid_size[0]):
		for y in range(grid_size[1]):
			var scene = scenes[y][x]
			scene.visible = false
	
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

func _update_current_scene():
	var player_pos = PlayerData.position
	var grid_size = WorldData.grid_size
	var scene_size = WorldData.scene_size
	
	current_scene = [
		clamp(floor(player_pos[0] / scene_size[0]), 0, grid_size[0]-1),
		clamp(floor(player_pos[1] / scene_size[1]), 0, grid_size[1]-1),
	]
	
	WorldData.current_scene = get_scene(current_scene)

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
	return scenes[xy[1]][xy[0]]

func get_current_biome() -> String:
	var scene = get_scene(current_scene)
	return scene.get_biome()
