extends State

var anim: AnimationPlayer

func enter():
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
