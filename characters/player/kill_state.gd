extends State

var anim: AnimationPlayer
var triggered: bool = false

func enter():
	triggered = false
	anim = parent_body.get_node("AnimationPlayer")
	anim.play("action/kill_1")
	anim.queue("action/kill_2")

func exit():
	return

func update(delta: float):
	if Input.is_action_just_pressed("use_item") and not triggered:
		anim.play("action/kill_3")
		triggered = true

func physics_update(delta: float):
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name != "action/kill_3":
		return
	
	state_transitioned.emit(self, "idle")
