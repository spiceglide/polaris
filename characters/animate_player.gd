extends Node2D

var loop: bool = true

func _ready() -> void:
	play()

func _process(delta: float) -> void:
	var is_end = $Body.frame == ($Body.sprite_frames.get_frame_count($Body.animation) - 1)
	if is_end and not loop:
		pause()
	
func set_direction(direction: String, action: String, is_holding: bool):
	loop = true
	
	if ("%s_%s" % [direction, action]) == $Body.animation:
		return
		
	# Holding items
	var hold = ""
	var item = null
	$Body.position.x = 0
	$Item.position.x = 0
	if is_holding:
		item = InventoryData.get_selected_item()
		hold = "_hold"
		
		if direction in ["north", "south", "east"]:
			$Body.position.x = 12.5
			$Item.position.x = 12.5
		elif direction == "west":
			$Body.position.x = -12.5
			$Item.position.x = -12.5
	
	reset_flip()
	
	match [direction, action]:
		["north", "idle"]:
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "none"
			$Puff.animation = "none"
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
		["north", "walk"]:
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "none"
			$Puff.animation = "none"
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
		["east", "idle"]:
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "none"
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
		["east", "walk"]:
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "none"
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
		["south", "idle"]:
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "%s_%s" % [direction, action]
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
		["south", "walk"]:
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "%s_%s" % [direction, action]
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
		["west", "idle"]:
			direction = "east"
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "none"
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
			$Body.flip_h = true
			$Face.flip_h = true
			$Puff.flip_h = true
			$Item.flip_h = true
		["west", "walk"]:
			direction = "east"
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "none"
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
			$Body.flip_h = true
			$Face.flip_h = true
			$Puff.flip_h = true
			$Item.flip_h = true
		
	play()

func set_state(state: String, loop: bool):
	self.loop = loop
	
	if state == $Body.animation:
		return
	
	reset_flip()
	$Body.animation = state
	$Face.animation = state
	$Puff.animation = state
	$Item.animation = "none"
	
	play()

func reset_progress():
	for segment in [$Body, $Face, $Puff, $Item]:
		segment.frame_progress = 0.0

func reset_flip():
	for segment in [$Body, $Face, $Puff, $Item]:
		segment.flip_h = false

func play():
	for segment in [$Body, $Face, $Puff, $Item]:
		segment.play()

func stop():
	for segment in [$Body, $Face, $Puff, $Item]:
		segment.stop()

func pause():
	for segment in [$Body, $Face, $Puff, $Item]:
		segment.pause()
