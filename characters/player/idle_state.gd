extends State

var anim: AnimationPlayer
var item_sprite: AnimatedSprite2D

func enter():
	anim = parent.get_node("AnimationPlayer")
	item_sprite = parent.get_node("Sprite/Item")

	# Play idle animation (with or without holding)
	var item = InventoryData.get_selected_item()
	var last_dir = parent.last_dir
	if item in InventoryData.holdable:
		item_sprite.animation = item + "_idle"
		anim.play("idle/" + last_dir + "_hold")
	else:
		anim.play("idle/" + last_dir)

func exit():
	pass

func update(delta: float):
	var item = InventoryData.get_selected_item()

	if PlayerData.health <= 0:
		state_transitioned.emit(self, "dead")
	
	# Potentially hold item
	if Input.is_action_just_pressed("hotbar") or Input.is_action_just_pressed("inv_prev") or Input.is_action_just_pressed("inv_next"):
		if item not in ["torch"]:
			var light = parent.get_node("Light")
			light.visible = false
		
		if item in InventoryData.holdable:
			state_transitioned.emit(self, "pullout")
		else:
			var last_dir = parent.last_dir
			anim.queue("idle/" + last_dir)
	
	# Use item
	if Input.is_action_just_pressed("use_item") and item != "":
		var data = InventoryData.get_selected_item_data()
		#parent.get_node("Notifications").announce(tr("ITEM_" + item.to_upper() + "_DESCRIPTION"))
		
		if "victim" in data.get("tags", []):
			state_transitioned.emit(self, "kill")
		
		if "placeable" in data.get("tags", []):
			parent.place_structure(item)

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

func physics_update(delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if movement.length() > 0:
		# Determine direction
		var last_dir: String = "south"
		if movement.y != 0:
			last_dir = "north" if movement.y < 0 else "south"
		else:
			last_dir = "west" if movement.x < 0 else "east"
		parent.last_dir = last_dir

		state_transitioned.emit(self, "walk")
