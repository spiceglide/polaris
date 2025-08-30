extends State

var anim: AnimationPlayer

func enter():
	var interactable = parent.interactable
	if len(interactable) > 0:
		var object = interactable[0]
		parent.global_position = object.parent.global_position - Vector2(0, 1)
		object.interact(parent, "crank")
	
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/crank")

	$Timer.start()

func exit():
	pass

func update(delta: float):
	pass

func physics_update(delta: float):
	pass

func _on_timer_timeout() -> void:
	state_transitioned.emit(self, "idle")
