extends Node2D
class_name Item

@export var item_id: String = ""
@export var title: String = ""
@export var description: String = ""
@export var consumable: bool = false

var item_map: Dictionary

func _ready() -> void:
	add_to_group("items")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_item(id: String):
	var data = InventoryData.item_map[id]
	item_id = id
	title = data["name"]
	description = data["description"]
	consumable = data["consumable"]

func use() -> bool:
	print("Used '%s'" % title)
	match item_id:
		"berries":
			PlayerData.hunger += 10
		"campfire":
			place_structure("Campfire")
		"smallfire":
			place_structure("SmallFire")
		"torch":
			match PlayerData.state:
				PlayerData.State.Awake:
					PlayerData.state = PlayerData.State.PullOut
				PlayerData.State.Holding:
					PlayerData.state = PlayerData.State.Awake
		"sleeping_bag":
			if WorldData.is_night():
				PlayerData.state = PlayerData.State.Sleeping
		"hatchet":
			PlayerData.sanity = 100
			match PlayerData.state:
				PlayerData.State.Awake:
					PlayerData.state = PlayerData.State.PullOut
				PlayerData.State.Holding:
					PlayerData.state = PlayerData.State.Awake
	return consumable

func place_structure(name: String) -> bool:
	var scene = WorldData.current_scene
	var tilemap = scene.get_node("TileMap")
	
	var instance = load('res://structures/%s.tscn' % name).instantiate()
	scene.add_child(instance)
	instance.position = PlayerData.position
	instance.position.x += 100
	return true
