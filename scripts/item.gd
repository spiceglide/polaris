extends Node2D
class_name Item

@export var id: String = ""
@export var title: String = ""
@export var description: String = ""

var item_map = {"rock": {"name": "Rock", "description": '"Better than nothing"'}}

func _ready() -> void:
	$Sprite.animation = id
	$Sprite.play()
	add_to_group("items")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create(id: String):
	var data = item_map[id]
	self.id = id
	self.name = data["name"]
	self.description = data["description"]
