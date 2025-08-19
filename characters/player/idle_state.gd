extends State

var anim: AnimationPlayer
var item_sprite: AnimatedSprite2D

func enter():
	anim = parent_body.get_node("AnimationPlayer")
	item_sprite = parent_body.get_node("Sprite/Item")

func exit():
	pass

func update(delta: float):
	var item = InventoryData.get_selected_item()
	
	# Play idle animation (with or without holding)
	var last_dir = parent_body.last_dir
	if item in InventoryData.holdable:
		item_sprite.animation = item + "_idle"
		anim.play("idle/" + last_dir + "_hold")
	else:
		anim.play("idle/" + last_dir)
	
	# Potentially hold item
	if Input.is_action_just_pressed("hotbar") or Input.is_action_just_pressed("inv_prev") or Input.is_action_just_pressed("inv_next"):
		if item in InventoryData.holdable:
			state_transitioned.emit(self, "pullout")
	
	# Use item
	if Input.is_action_just_pressed("use_item"):
		if item in ["frog", "hare"]:
			state_transitioned.emit(self, "kill")
	
	# Interact with environment
	if Input.is_action_just_pressed("interact"):
		match item:
			"hatchet":
				state_transitioned.emit(self, "chop")
			_:
				state_transitioned.emit(self, "gather")

func physics_update(delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if movement.length() > 0:
		state_transitioned.emit(self, "walk")
