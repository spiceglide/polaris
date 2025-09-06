extends State

var anim: AnimationPlayer
var anim_finished: bool = false

func enter():
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/death_1")
	anim.queue("action/death_2")

func exit():
	pass

func update(_delta: float):
	if anim_finished and Input.is_anything_pressed():
		SceneSwitcher.load_main_menu()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "action/death_2":
		return
	
	anim_finished = true
