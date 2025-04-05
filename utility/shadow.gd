extends Sprite2D

func _ready() -> void:
	$Shadow.texture = texture;
	
	var height = self.texture.get_height()
	var disp = self.position.y;
	var offset = (height/2)+disp
	
	$Shadow.position.y -= offset/2
