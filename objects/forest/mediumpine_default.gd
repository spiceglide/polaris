extends State

var anim: AnimationPlayer

func enter():
	anim = parent.get_node("AnimationPlayer")
	anim.play("default")
