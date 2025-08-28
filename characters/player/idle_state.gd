extends State

var anim: AnimationPlayer
var item_sprite: AnimatedSprite2D

func enter():
	anim = parent.get_node("AnimationPlayer")
	item_sprite = parent.get_node("Sprite/Item")

func exit():
	pass

func update(delta: float):
	var item = InventoryData.get_selected_item()
	
	# Play idle animation (with or without holding)
	var last_dir = parent.last_dir
	if item in InventoryData.holdable:
		item_sprite.animation = item + "_idle"
		anim.play("idle/" + last_dir + "_hold")
	else:
		anim.play("idle/" + last_dir)
	
	# Potentially hold item
	if Input.is_action_just_pressed("hotbar") or Input.is_action_just_pressed("inv_prev") or Input.is_action_just_pressed("inv_next"):
		if item not in ["torch"]:
			var light = parent.get_node("Light")
			light.visible = false
		
		if item in InventoryData.holdable:
			state_transitioned.emit(self, "pullout")
	
	# Use item
	if Input.is_action_just_pressed("use_item") and item != "":
		var data = InventoryData.get_selected_item_data()
		parent.get_node("Notifications").announce(tr("ITEM_" + item.to_upper() + "_DESCRIPTION"))
		
		if "victim" in data.get("tags", []):
			state_transitioned.emit(self, "kill")
		
		if "placeable" in data.get("tags", []):
			parent.place_structure(item)
		
		InventoryData.use_selected_item()
	
	# Interact with environment
	if Input.is_action_just_pressed("interact"):
		if len(parent.interactable) > 0:
			var object = parent.interactable[0]
			var interactions = ["gather"]

			if item == "hatchet":
					interactions.append("chop")

			var interaction = object.select_interaction_type(interactions)
			if interaction:
				state_transitioned.emit(self, interaction)

func physics_update(delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if movement.length() > 0:
		state_transitioned.emit(self, "walk")
