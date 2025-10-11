extends State

var anim: AnimationPlayer

func toggle_menu(state: bool):
	get_tree().call_group("station", "_toggle_menu", state)

func apply_recipe(state: bool):
	if (state == false) or (len(parent.interactable) == 0):
		get_tree().call_group("station", "_apply_station", "")
	else:
		get_tree().call_group("station", "_apply_station", parent.interactable[0])

func enter():
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/gather_1")
	
	apply_recipe(true)
	toggle_menu(true)

func exit():
	apply_recipe(false)

func update(_delta: float):
	if Input.is_action_just_pressed("inventory"):
		state_transitioned.emit(self, "walk")

func physics_update(_delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if (movement.length() > 0):
		state_transitioned.emit(self, "walk")
		toggle_menu(false)
