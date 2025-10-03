extends Container

var item: String = ""

func set_item(id: String):
	item = id
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
	$ItemSprite.visible = false
	
func enable():
	$Sprite.modulate = Color(1, 1, 1)

func disable():
	$Sprite.modulate = Color(0.6, 0.6, 0.6)
