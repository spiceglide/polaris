extends Sprite2D

var elapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed += 1

	if (elapsed % 40) == 0:
		var seconds = (elapsed / 60)
		
		self.skew = -(((seconds % 600) / 200.0) - 1.5)
		#self.scale.y = abs(((seconds % 600) * (0.84/600)) - 0.42)
