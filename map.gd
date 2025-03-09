extends Node2D

@export var grid_size = [9, 9]
var scene_size = [3000, 3000]
var scenes = [preload("res://scene1.tscn"), preload("res://scene2.tscn")]

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
