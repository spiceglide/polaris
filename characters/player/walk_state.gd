extends State

var direction: Vector2 = Vector2.ZERO
var anim: AnimationPlayer
var item_sprite: AnimatedSprite2D

func enter():
	direction = Vector2.ZERO
	anim = parent.get_node("AnimationPlayer")
	item_sprite = parent.get_node("Sprite/Item")

	var item = InventoryData.get_selected_item()
	var data = InventoryData.get_selected_item_data()
	
	var last_dir = parent.last_dir
	if "holdable" in data.get("tags", []):
		item_sprite.animation = item
		anim.play("walk/" + last_dir + "_hold")
	else:
		anim.play("walk/" + last_dir)

func exit():
	direction = Vector2.ZERO

func update(_delta: float):
	var item = InventoryData.get_selected_item()

	if PlayerData.health <= 0:
		state_transitioned.emit(self, "dead")
	
	# Potentially hold item
	if Input.is_action_just_pressed("hotbar") or Input.is_action_just_pressed("inv_prev") or Input.is_action_just_pressed("inv_next"):
		var data := InventoryData.get_selected_item_data()
		
		if "light" in data.get("tags", []):
			var light = parent.get_node("Light")
			light.visible = false
		
		if "holdable" in data.get("tags", []):
			state_transitioned.emit(self, "pullout")
		else:
			var last_dir = parent.last_dir
			anim.queue("walk/" + last_dir)
	
	# Use item
	if Input.is_action_just_pressed("use_item") and item != "":
		var data = InventoryData.get_selected_item_data()
		#parent.get_node("Notifications").announce(tr("ITEM_" + item.to_upper() + "_DESCRIPTION"))
		
		if "food" in data.get("tags", []):
			state_transitioned.emit(self, "eat")
		
		if "victim" in data.get("tags", []):
			state_transitioned.emit(self, "kill")
			InventoryData.use_selected_item()
		
		if "placeable" in data.get("tags", []):
			parent.place_structure(item)
			InventoryData.use_selected_item()
		
		if "sleep" in data.get("tags", []):
			state_transitioned.emit(self, "sleep")
			InventoryData.use_selected_item()
	
	# Interact with environment
	if Input.is_action_just_pressed("interact"):
		if len(parent.interactable) > 0:
			var object = parent.interactable[0]
			var interactions = parent.get_possible_interactions()
			
			if item in ["hatchet"]:
					interactions.append("chop")
					
			var interaction = object.select_interaction_type(interactions)
			if interaction:
				state_transitioned.emit(self, interaction)

func physics_update(_delta: float):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Speed multiplier
	var mult = 1
	if Input.is_action_pressed("run"):
		mult = PlayerData.multiplier
	
	# Process
	if direction.length() > 0:
		parent.velocity = direction.normalized() * PlayerData.speed * mult
		parent.move_and_slide()
		
		# Determine direction
		var last_dir: String = "south"
		if direction.y != 0:
			last_dir = "north" if direction.y < 0 else "south"
		else:
			last_dir = "west" if direction.x < 0 else "east"
		parent.last_dir = last_dir

		var item = InventoryData.get_selected_item()
		var data = InventoryData.get_selected_item_data()
		
		if "holdable" in data.get("tags", []):
			item_sprite.animation = item
			anim.play("walk/" + last_dir + "_hold")
		else:
			anim.play("walk/" + last_dir)
	else:
		state_transitioned.emit(self, "idle")
