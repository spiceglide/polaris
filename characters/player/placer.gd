extends Node2D

@export var placer: PhysicsBody2D
@export var offset: float = 40.0
var size: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	match placer.last_dir:
		"north":
			position = Vector2(0.0, -(offset + size.y))
		"south":
			position = Vector2(0.0, offset + size.y)
		"east":
			position = Vector2(offset + size.x, 0.0)
		"west":
			position = Vector2(-(offset + size.x), 0.0)


func place(title: String) -> bool:
	#var tilemap: TileMap = scene.get_node("TileMap")
	
	var struct: Resource = load('res://structures/%s.tscn' % title)
	var instance: Variant = struct.instantiate()

	var rect: Node = instance.get_node_or_null("CollisionShape2D")
	if not rect:
		return false
	
	if "size" in rect.shape:
		self.size = rect.shape.size
	else:
		self.size = Vector2(50.0, 50.0)

	instance.process_mode = Node.PROCESS_MODE_DISABLED
	var shadow = instance.get_node_or_null("Sprite2D/Shadow")
	if shadow:
		shadow.visible = false
	self.add_child(instance)

	return true

func complete():
	var scene = WorldData.current_scene
	var instance = self.get_child(0)
	if instance:
		self.remove_child(instance)
		scene.add_child(instance)
		instance.global_position = self.global_position
		instance.process_mode = Node.PROCESS_MODE_INHERIT
		var shadow = instance.get_node_or_null("Sprite2D/Shadow")
		if shadow:
			shadow.visible = true

func cancel():
	for child in self.get_children():
		child.queue_free()
