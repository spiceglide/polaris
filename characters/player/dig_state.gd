extends State

var anim: AnimationPlayer

func enter():
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/dig")
	$Timer.start()

func exit():
	$Timer.stop()

func physics_update(_delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if (movement.length() > 0):
		state_transitioned.emit(self, "walk")

func _on_timer_timeout() -> void:
	var interactable = parent.interactable
	if len(interactable) > 0:
		interactable[0].interact(parent, "dig")
	
	parent.last_dir = "north"
	state_transitioned.emit(self, "idle")
