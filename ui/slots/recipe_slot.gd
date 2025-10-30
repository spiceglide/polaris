extends Container

var item: GameItem = null

func set_item(item: GameItem, quantity: int = 1):
	self.item = item
	%Quantity.text = str(quantity)
	%Quantity.visible = quantity not in [0, 1]
	self.tooltip_text = '%s\n"%s"' % [
		item.tr_name(),
		item.tr_description(),
	]
	
	if $ItemSprite.sprite_frames.has_animation(item.id):
		$ItemSprite.animation = item.id
	else:
		$ItemSprite.animation = "default"
	$ItemSprite.visible = true

func clear_item():
	item = null
	%Quantity.visible = false
	$ItemSprite.visible = false
	
func enable():
	$Sprite.modulate = Color(1, 1, 1)

func disable():
	$Sprite.modulate = Color(0.6, 0.6, 0.6)
