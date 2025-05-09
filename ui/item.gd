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
			pass
		"smallfire":
			pass
		"torch":
			match PlayerData.state:
				PlayerData.State.Awake:
					PlayerData.state = PlayerData.State.PullOut
				PlayerData.State.Holding:
					PlayerData.state = PlayerData.State.Awake
		"sleeping_bag":
			if WorldData.is_night():
				PlayerData.state = PlayerData.State.Sleeping
	
	return consumable
