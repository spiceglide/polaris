extends Node2D

@export var fade: float = 0.4
@export var width: Vector2 = Vector2(20.0, 4.0)

@onready var footstep: Resource = load("res://characters/player/footstep.tscn")
var right_foot: bool = true

func _process(delta: float) -> void:
	for follower in self.get_children():
		if follower.modulate.a > 0:
			follower.modulate.a -= delta * fade
		else:
			follower.queue_free()

func new_step() -> void:
	var step: Sprite2D = footstep.instantiate()
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	step.rotation = direction.angle()
	step.global_position = self.global_position

	if right_foot:
		step.position.x += width.x * direction.y
		step.position.y += width.y * direction.x
		right_foot = false
	else:
		step.position.x -= width.x * direction.y
		step.position.y -= width.y * direction.x
		right_foot = true

	self.add_child(step)
