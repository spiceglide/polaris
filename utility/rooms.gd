extends Node

func _ready() -> void:
	update_rooms()

func update_rooms():
	print(self.get_children())
	SceneSwitcher.rooms = self.get_children()

func _on_child_entered_tree(_node: Node) -> void:
	update_rooms()
