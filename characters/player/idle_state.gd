extends State

var anim: AnimationPlayer

func enter():
	anim = parent_body.get_node("AnimationPlayer")

func exit():
	pass

func update(delta: float):
	var last_dir = parent_body.last_dir
	if parent_body.item:
		anim.play("idle/" + last_dir + "_hold")
	else:
		anim.play("idle/" + last_dir)
	
	if Input.is_action_just_pressed("use_item"):
		if parent_body.item:
			parent_body.item = ""
		else:
			var item = InventoryData.get_selected_item()
			if item in InventoryData.holdable:
				state_transitioned.emit(self, "pullout")
			elif item in ["frog", "hare"]:
				state_transitioned.emit(self, "kill")
	
	if Input.is_action_just_pressed("interact"):
		if parent_body.item == "hatchet":
			state_transitioned.emit(self, "chop")
		else:
			state_transitioned.emit(self, "gather")

func physics_update(delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if movement.length() > 0:
		state_transitioned.emit(self, "walk")
