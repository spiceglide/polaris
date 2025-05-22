extends Container

var item: Item = null

func set_item(id: String):
	item = $Item
	item.set_item(id)
	
	$ItemSprite.animation = id
	$ItemSprite.visible = true

func clear_item():
	item = null
	$ItemSprite.visible = false
	
func enable():
	$Sprite.modulate = Color(1, 1, 1)

func disable():
	$Sprite.modulate = Color(0.6, 0.6, 0.6)
