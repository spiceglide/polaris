extends BoxContainer

@export var anims: Array = ["type1", "type2", "type3", "type4", "type5"]
@export var node_name: String = "Sprite"

func _ready() -> void:
	_init_animations()

func _init_animations():
	var counter = 0
	var children = self.get_children()
	
	for node in children:
		var sprite = node.get_node(node_name)
		sprite.animation = anims[counter % len(anims)]
		counter += 1
	pass


func _on_child_entered_tree(node: Node) -> void:
	_init_animations()
