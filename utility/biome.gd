extends Node2D

@onready var space: Vector2 = $TileMap/base.get_used_rect().size * $TileMap/base.tile_set.tile_size

@export var biomes: Array = ["tundra"]
@export var creature_limit: int = 4
@export var structure_limit: int = 9

var biome_data: Dictionary = {
	"tundra": {
		"creatures": [],
		"structures": ["Campfire", "SmallFire", "Well"],
	},
	"forest": {
		"creatures": ["Hare"],
		"structures": ["Campfire", "SmallFire"],
	},
	"swamp": {
		"creatures": ["Frog"],
		"structures": ["Campfire", "SmallFire"],
	},
}

func _ready() -> void:
	set_biome()
	
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
			var point = WorldData.get_random_point(space)
			
			var instance = load('res://characters/creatures/%s.tscn' % creature).instantiate()
			self.add_child(instance)
			instance.position = point
	
	# Generate structures
	if not structures.is_empty():
		var structure_count = randi() % structure_limit
		for i in range(structure_count):
			var structure = structures.pick_random()
			var point = WorldData.get_random_point(space)
			
			var instance = load('res://structures/%s.tscn' % structure).instantiate()
			self.add_child(instance)
			instance.position = point

func set_biome():
	self.biomes = []
	var biomes = biome_data.keys()
	
	var path = self.scene_file_path.get_file().get_basename()
	for part in path.split('_'):
		if part in biomes:
			self.biomes.append(part)

func get_biome() -> String:
	return biomes[0]
