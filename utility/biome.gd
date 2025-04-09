extends Node2D

@onready var space: Vector2 = $TileMap.get_used_rect().size * $TileMap.tile_set.tile_size

@export var biomes: Array = ["tundra"]
@export var creature_limit: int = 3
@export var structure_limit: int = 1

var biome_data: Dictionary = {
	"tundra": {
		"creatures": [],
		"structures": [],
	},
	"forest": {
		"creatures": [],
		"structures": [],
	},
	"swamp": {
		"creatures": ["frog"],
		"structures": [],
	},
}

func _ready() -> void:
	var creatures = []
	var structures = []
	
	# Combine data for hybrid biomes
	for biome in biomes:
		var data = biome_data[biome]
		creatures.append_array(data['creatures'])
		structures.append_array(data['structures'])
	
	# Generate creatures
	if not creatures.is_empty():
		var creature_count = randi() % creature_limit
		for i in range(creature_count):
			var creature = creatures.pick_random().capitalize()
			var point = _get_random_point(space)
			
			var instance = load('res://characters/creatures/%s.tscn' % creature).instantiate()
			self.add_child(instance)
			instance.position = point
	
	#var structure_count = randi() % structure_limit

func get_biome() -> String:
	return biomes[-1]

func _get_random_point(rect: Vector2) -> Vector2:
	var x = randi() % int(rect.x)
	var y = randi() % int(rect.y)
	return Vector2(x, y)
