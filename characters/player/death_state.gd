extends State

var anim: AnimationPlayer

func enter():
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/death_1")
	anim.queue("action/death_2")

func exit():
	pass

func update(delta: float):
	pass

func physics_update(delta: float):
	pass
