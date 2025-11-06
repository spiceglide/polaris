extends State

func enter():
	var anim_player := parent.get_node("AnimationPlayer")
	if anim_player:
		anim_player.play("unlit")

	var audio := self.get_node_or_null("AudioStreamPlayer2D")
	if audio:
		audio.play()
	
	var light := parent.get_node("Light")
	if light:
		light.visible = false
