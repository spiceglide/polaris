extends State

@export var animations: Array

func enter():
	if len(animations) > 0:
		var anim_player := parent.get_node("AnimationPlayer")
		if not anim_player:
			return

		anim_player.play(self.name.to_lower())
		for anim in animations.slice(1):
			anim.queue(anim)

	var audio := self.get_node_or_null("AudioStreamPlayer2D")
	if audio:
		audio.play()
