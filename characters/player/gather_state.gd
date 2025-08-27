extends State

var anim: AnimationPlayer
var exitable: bool = false

func enter():
	exitable = false
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/gather_1")
	anim.queue("action/gather_2")
	$Timer.start()

func exit():
	exitable = false
	$Timer.stop()

func update(delta: float):
	pass

func physics_update(delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if (movement.length() > 0) and exitable:
		state_transitioned.emit(self, "walk")

func _on_timer_timeout() -> void:
	var interactable = parent.interactable
	if len(interactable) > 0:
		interactable[0].interact(parent, "gather")
	
	parent.last_dir = "north"
	state_transitioned.emit(self, "idle")

func _on_animation_player_animation_changed(old_name: StringName, new_name: StringName) -> void:
	if [old_name, new_name] == [&"action/gather_1", &"action/gather_2"]:
		exitable = true
