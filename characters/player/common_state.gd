extends Node

signal state_transitioned

func handle_life(caller: State):
	if PlayerData.health <= 0:
		state_transitioned.emit(caller, "dead")

func handle_holding(caller: State, root: CharacterBody2D):
	if not root.holding:
		return
	
	var data = InventoryData.get_item_data(root.holding)
	if not data:
		return
	
	var tags = data.get("tags", [])
	var prev_state = caller.name.to_lower()
	
	if Input.is_action_just_pressed("hotbar") or Input.is_action_just_pressed("inv_prev") or Input.is_action_just_pressed("inv_next"):
		root.holding = null
		caller.anim.queue(prev_state + "/" + root.last_dir)
		return
	
	if "light" in tags:
		var light = root.get_node("Light")
		light.visible = false
	
	if "holdable" in tags:
		caller.anim.play(prev_state + "/" + root.last_dir + "_hold")
	else:
		caller.anim.play(prev_state + "/" + root.last_dir)

func handle_consumption(caller: State, root: CharacterBody2D):
	var item = InventoryData.get_selected_item()
	
	# Use item
	if Input.is_action_just_pressed("use_item") and item != "":
		var data = InventoryData.get_item_data(item)
		var tags: Array = data.get("tags", [])
		#parent.get_node("Notifications").announce(tr("ITEM_" + item.to_upper() + "_DESCRIPTION"))
		
		if "food" in tags:
			caller.state_transitioned.emit(caller, "eat")
		
		if "victim" in tags:
			caller.state_transitioned.emit(caller, "kill")
			InventoryData.use_selected_item()
		
		if "placeable" in tags:
			root.place_structure(item)
			InventoryData.use_selected_item()
		
		if "sleep" in tags:
			caller.state_transitioned.emit(caller, "sleep")
			InventoryData.use_selected_item()
		
		if "holdable" in tags:
			if root.holding:
				root.holding = null
				var state = caller.name.to_lower()
				caller.anim.play(state + "/" + root.last_dir)
			else:
				root.holding = item
				caller.state_transitioned.emit(caller, "pullout")

func handle_interaction(caller: State, root: CharacterBody2D):
	# Interact with environment
	if Input.is_action_just_pressed("interact"):
		if len(root.interactable) > 0:
			var object = root.interactable[0]
			var interactions = root.get_possible_interactions()
			
			var interaction = object.select_interaction_type(interactions)
			if interaction:
				print(interaction)
				caller.state_transitioned.emit(caller, interaction)
