extends Node2D

func _ready() -> void:
	$Body.play()
	$Face.play()
	$Puff.play()
	
func set_state(direction: String, action: String):
	for segment in [$Body, $Face, $Puff]:
		segment.flip_h = false
	
	match [direction, action]:
		["north", "idle"]:
			$Body.animation = "%s_%s" % [direction, action]
			$Face.animation = "none"
			$Puff.animation = "none"
		["north", "walk"]:
			$Body.animation = "%s_%s" % [direction, action]
			$Face.animation = "none"
			$Puff.animation = "none"
		["east", "idle"]:
			$Body.animation = "%s_%s" % [direction, action]
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "none"
		["east", "walk"]:
			$Body.animation = "%s_%s" % [direction, action]
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "none"
		["south", "idle"]:
			$Body.animation = "%s_%s" % [direction, action]
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "%s_%s" % [direction, action]
		["south", "walk"]:
			$Body.animation = "%s_%s" % [direction, action]
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "%s_%s" % [direction, action]
		["west", "idle"]:
			direction = "east"
			$Body.animation = "%s_%s" % [direction, action]
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "none"
			$Body.flip_h = true
			$Face.flip_h = true
			$Puff.flip_h = true
		["west", "walk"]:
			direction = "east"
			$Body.animation = "%s_%s" % [direction, action]
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "none"
			$Body.flip_h = true
			$Face.flip_h = true
			$Puff.flip_h = true
		
	for segment in [$Body, $Face, $Puff]:
		segment.play()
