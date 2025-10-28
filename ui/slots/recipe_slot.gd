extends Container

var item: String = ""

func set_item(id: String, quantity: int = 1):
	item = id
	%Quantity.text = str(quantity)
	%Quantity.visible = quantity not in [0, 1]
	self.tooltip_text = '%s\n"%s"' % [
		tr("ITEM_" + id.to_upper() + "_NAME"),
		tr("ITEM_" + id.to_upper() + "_DESCRIPTION"),
	]
	
	if $ItemSprite.sprite_frames.has_animation(id):
		$ItemSprite.animation = id
	else:
		$ItemSprite.animation = "default"
	$ItemSprite.visible = true

func clear_item():
	item = ""
	%Quantity.visible = false
	$ItemSprite.visible = false
	
func enable():
	$Sprite.modulate = Color(1, 1, 1)

func disable():
	$Sprite.modulate = Color(0.6, 0.6, 0.6)
