extends Container

func set_recipe(recipe: Dictionary, craftable: bool):
	var output = recipe["out"]
	var ingredients = recipe["in"]
	
	$Crafted.set_item(GameItem.new(output))
	if craftable:
		$Crafted.enable()
	else:
		$Crafted.disable()
	
	var counter = 0
	for slot in $Recipe.get_children():
		if counter >= len(ingredients):
			slot.clear_item()
			slot.disable()
		else:
			var ingr = ingredients[counter]
			
			slot.set_item(GameItem.new(ingr))
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
