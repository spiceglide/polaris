extends State

var anim: AnimationPlayer

func enter():
	anim = parent_body.get_node("AnimationPlayer")
	anim.play("action/pull")

func exit():
	pass

func update(delta: float):
	pass

func physics_update(delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if movement.length() > 0:
		state_transitioned.emit(self, "walk")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "action/pull":
		return
	
	parent_body.last_dir = "south"
	state_transitioned.emit(self, "idle")
