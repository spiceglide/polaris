extends State

var anim: AnimationPlayer

func enter():
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/death_2")
	$Timer.play()

func exit():
	pass

func update(delta: float):
	pass

func physics_update(delta: float):
	pass

func _on_timer_timeout() -> void:
	if WorldData.is_night():
		SceneSwitcher.load_dream_game()
