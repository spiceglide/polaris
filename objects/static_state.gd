extends State

@export var animations: Array

func enter():
	if len(animations) > 0:
		var anim_player = parent.get_node("AnimationPlayer")

		anim_player.play(animations.front())
		for anim in animations.slice(1):
			anim.queue(anim)

	var audio = self.get_node_or_null("AudioStreamPlayer2D")
	if audio:
		audio.play()
