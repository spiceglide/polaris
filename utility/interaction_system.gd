extends Area2D

@onready var player = self.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		for area: Area2D in get_overlapping_areas():
			print("cool area")
			if area.has_method("interact"):
				print("cool")
				area.interact(player)
				break
