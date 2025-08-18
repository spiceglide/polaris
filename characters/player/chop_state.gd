extends State

var anim: AnimationPlayer

func enter():
	anim = parent_body.get_node("AnimationPlayer")
	anim.play("action/chop_1")
	anim.queue("action/chop_2")
	$Timer.start()

func exit():
	$Timer.stop()

func update(delta: float):
	pass

func physics_update(delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if movement.length() > 0:
		state_transitioned.emit(self, "walk")

func _on_timer_timeout() -> void:
	state_transitioned.emit(self, "idle")
