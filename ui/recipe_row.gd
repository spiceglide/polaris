extends Container

func set_recipe(recipe: Dictionary, craftable: bool):
	var output = recipe["out"]
	var ingredients = {}
	for ingr in recipe["in"]:
		ingredients[ingr] = ingredients.get(ingr, 0) + 1
	
	
	var inputs: Array[GameItem]
	inputs.assign( recipe["in"].map(func (x): return GameItem.new(x)) )
	$Crafted.set_item(GameItem.new(output))
	$Crafted.set_inputs(inputs)
	
	if len(recipe.get("stations", [])) > 0:
		mark_color(true)
	else:
		mark_color(false)
	
	if craftable:
		$Crafted.enable()
	else:
		$Crafted.disable()
	
	var counter = 0
	var ingr_keys = ingredients.keys()
	for slot in $Recipe.get_children():
		if counter >= len(ingr_keys):
			slot.clear_item()
			slot.disable()
		else:
			var item = ingr_keys[counter]
			var quantity = ingredients[item]
			
			slot.set_item(GameItem.new(item), quantity)
			if craftable:
				slot.enable()
			else:
				slot.disable()
			
		counter += 1

func clear_recipe():
	$Crafted.clear_item()
	$Crafted.disable()
	
	for slot in $Recipe.get_children():
		slot.clear_item()
		slot.disable()

func mark_color(state: bool):
	var color: Color
	color = Color("#ffdba2") if state else Color(1, 1, 1)

	$Crafted/Sprite.self_modulate = color
	for slot in $Recipe.get_children():
		var frame = slot.get_node_or_null("Sprite")
		if frame:
			frame.self_modulate = color
