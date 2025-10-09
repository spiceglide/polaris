extends State

var anim: AnimationPlayer

func toggle_menu(state: bool):
	get_tree().call_group("ui", "set_ui_element", "inventory", state)

func enter():
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/gather_1")
	
	toggle_menu(true)

func exit():
	pass

func update(_delta: float):
	if Input.is_action_just_pressed("inventory"):
		state_transitioned.emit(self, "walk")

func physics_update(_delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if (movement.length() > 0):
		state_transitioned.emit(self, "walk")
		toggle_menu(false)
