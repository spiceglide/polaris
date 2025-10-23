extends Node

signal state_transitioned

func handle_life(caller: State):
	if PlayerData.health <= 0:
		state_transitioned.emit(caller, "dead")

func handle_holding(caller: State, root: CharacterBody2D):
	var prev_state = caller.name.to_lower()
	
	# Potentially hold item
	if Input.is_action_just_pressed("hotbar") or Input.is_action_just_pressed("inv_prev") or Input.is_action_just_pressed("inv_next"):
		var data = InventoryData.get_selected_item_data()
		
		if "light" in data.get("tags", []):
			var light = root.get_node("Light")
			light.visible = false
		
		if "holdable" in data.get("tags", []):
			state_transitioned.emit(self, "pullout")
		else:
			var last_dir = root.last_dir
			caller.anim.queue(prev_state + "/" + last_dir)

func handle_consumption(caller: State, root: CharacterBody2D):
	var item = InventoryData.get_selected_item()
	
	# Use item
	if Input.is_action_just_pressed("use_item") and item != "":
		var data = InventoryData.get_selected_item_data()
		#parent.get_node("Notifications").announce(tr("ITEM_" + item.to_upper() + "_DESCRIPTION"))
		
		if "food" in data.get("tags", []):
			caller.state_transitioned.emit(self, "eat")
		
		if "victim" in data.get("tags", []):
			caller.state_transitioned.emit(self, "kill")
			InventoryData.use_selected_item()
		
		if "placeable" in data.get("tags", []):
			root.place_structure(item)
			InventoryData.use_selected_item()
		
		if "sleep" in data.get("tags", []):
			caller.state_transitioned.emit(self, "sleep")
			InventoryData.use_selected_item()

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
