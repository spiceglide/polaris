extends Node2D

var loop: bool = true

func _ready() -> void:
	play()

func _process(delta: float) -> void:
	var is_end = $Body.frame == ($Body.sprite_frames.get_frame_count($Body.animation) - 1)
	if is_end and not loop:
		pause()
	
func set_direction(direction: String, action: String):
	loop = true
	
	if ("%s_%s" % [direction, action]) == $Body.animation:
		return
	
	reset_flip()
	
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
		
	play()

func set_state(state: String, loop: bool):
	self.loop = loop
	
	if state == $Body.animation:
		return
	
	reset_flip()
	$Body.animation = state
	$Face.animation = state
	$Puff.animation = state
	
	play()


func reset_flip():
	for segment in [$Body, $Face, $Puff]:
		segment.flip_h = false

func play():
	for segment in [$Body, $Face, $Puff]:
		segment.play()

func pause():
	for segment in [$Body, $Face, $Puff]:
		segment.pause()
