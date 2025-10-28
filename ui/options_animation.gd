extends AnimationPlayer

func _ready() -> void:
	play_animation()

func play_animation():
	self.play("idle")
	
	var loops := randi() % 5 + 5
	for _i in range(loops):
		self.queue("messing")
		self.queue("idle")
	
	self.queue("ohshit")
	self.queue("spooked")
	
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spooked":
		play_animation()
