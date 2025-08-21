extends Container

var item: String = ""

func set_item(id: String):
	item = id
	
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
