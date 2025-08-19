extends State

var direction: Vector2 = Vector2.ZERO
var anim: AnimationPlayer
var item_sprite: AnimatedSprite2D

func enter():
	direction = Vector2.ZERO
	anim = parent_body.get_node("AnimationPlayer")
	item_sprite = parent_body.get_node("Sprite/Item")
	$Audio.play()

func exit():
	direction = Vector2.ZERO
	$Audio.stop()

func update(delta: float):
	var item = InventoryData.get_selected_item()
	
	# Play idle animation (with or without holding)
	var last_dir = parent_body.last_dir
	if item in InventoryData.holdable:
		item_sprite.animation = item + "_walk"
		anim.play("walk/" + last_dir + "_hold")
	else:
		anim.play("walk/" + last_dir)
	
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
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Speed multiplier
	var mult = 1
	if Input.is_action_pressed("run"):
		mult = PlayerData.multiplier
	
	# Process
	if direction.length() > 0:
		parent_body.velocity = direction.normalized() * PlayerData.speed * mult
		parent_body.move_and_slide()
		
		# Determine direction
		var last_dir: String = "south"
		if direction.y != 0:
			last_dir = "north" if direction.y < 0 else "south"
		else:
			last_dir = "west" if direction.x < 0 else "east"
		parent_body.last_dir = last_dir
	else:
		state_transitioned.emit(self, "idle")
