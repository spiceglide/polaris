extends Container

func set_recipe(recipe: Dictionary, craftable: bool):
	var output = recipe["out"]
	var ingredients = {}
	for ingr in recipe["in"]:
		ingredients[ingr] = ingredients.get(ingr, 0) + 1
	
	$Crafted.set_item(GameItem.new(output))
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
