extends Node2D

@export var grid_size = [3, 3]
var scene_size = [13440, 13440]
#var scenes = [preload("res://scenes/scene1.tscn"), preload("res://scenes/scene2.tscn"), preload("res://scenes/scene3.tscn")]
var scenes = [preload("res://scenes/scenes/Level_Snow_1.tscn")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene
	var instance
	
	for x in range(grid_size[0]):
		for y in range(grid_size[1]):
			scene = scenes.pick_random()
			instance = scene.instantiate()
			instance.position.x = scene_size[0] * x
			instance.position.y = scene_size[1] * y
			add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
