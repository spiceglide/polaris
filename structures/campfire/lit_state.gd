extends State

@export var brightness: float = 1.0
@export var duration: float = 60*9
var time_used: float = 0
var light: PointLight2D

func enter():
	var anim_player := parent.get_node("AnimationPlayer")
	if anim_player:
		anim_player.play("lit")

	var audio := self.get_node_or_null("AudioStreamPlayer2D")
	if audio:
		audio.play()
	
	light = parent.get_node("Light")
	if light:
		light.visible = false

func _process(delta: float) -> void:
	if not light:
		return
	
	time_used += delta
	light.texture_scale = brightness * (1.0 - (time_used / duration) ** 4)
	
	if time_used > duration:
		state_transitioned.emit(self, "burnt")
