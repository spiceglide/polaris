extends State

var anim: AnimationPlayer

func enter():
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/death_2")
	$Timer.start()

func exit():
	$Timer.stop()

func _process(_delta: float) -> void:
	if not WorldData.is_night():
		state_transitioned.emit(self, "idle")

func _on_timer_timeout() -> void:
	if WorldData.is_night():
		SceneSwitcher.load_dream_game()
