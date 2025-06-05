extends Node2D

@export var state: State = State.Unignited
@export var max_uses: int = 6
var times_used: int = 0

enum State {
	Unignited,
	Ignited,
	Extinguished,
}

func _ready() -> void:
	var interact_node = self.find_child("Interaction")
	interact_node.connect("interaction", _on_interaction)

func interact():
	times_used += 1
	
	if times_used > max_uses:
		state = State.Extinguished
		$AnimatedSprite2D.animation = "extinguished"
		return
	
	match state:
		State.Unignited:
			state = State.Ignited
			$AnimatedSprite2D.animation = "ignited"
			$Light.visible = true
		State.Ignited:
			state = State.Unignited
			$AnimatedSprite2D.animation = "unignited"
			$Light.visible = false

func _on_interaction():
	interact()
