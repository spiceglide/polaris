extends Node2D

func _ready() -> void:
	play()
	
func set_direction(direction: String, action: String, is_holding: bool):
	if ("%s_%s" % [direction, action]) == $Body.animation:
		return
	
	reset_flip()
	
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
	
	match [direction, action]:
		["north", "idle"], ["north", "walk"]:
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "none"
			$Puff.animation = "none"
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
		["south", "idle"], ["south", "walk"]:
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "%s_%s" % [direction, action]
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
		["east", "idle"], ["east", "walk"]:
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "none"
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
		["west", "idle"], ["west", "walk"]:
			direction = "east"
			$Body.animation = ("%s_%s" % [direction, action]) + hold
			$Face.animation = "%s_%s" % [direction, action]
			$Puff.animation = "none"
			$Item.animation = ("%s_%s_%s" % [item, direction, action]) if item else "none"
			$Body.flip_h = true
			$Face.flip_h = true
			$Puff.flip_h = true
			$Item.flip_h = true
		[_, "sleep"], [_, "death"]:
			$Item.animation = "none"
			for segment in [$Body, $Face, $Puff]:
				segment.animation = action
				segment.offset.x = 70
		[_, "pull"]:
			$Item.animation = "none"
			for segment in [$Body, $Face, $Puff]:
				segment.animation = action
		[_, "kill_1"], [_, "kill_2"], [_, "kill_3"]:
			var vars = action.split("_")
			var victim = InventoryData.get_selected_item()
			var weapon = "rock"
			var act = vars[0]
			var stage = int(vars[1])
			
			$Body.animation = "%s_%s" % [act, stage]
			$Face.animation = "%s_%s" % [act, stage]
			$Puff.animation = "%s_%s_%s" % [act, victim, min(2, stage)]
			$Item.animation = "%s_%s_%s" % [weapon, act, stage]
			
			for segment in [$Body, $Face, $Puff, $Item]:
				segment.offset.x = 27
				segment.offset.y = 6
		
	play()

func reset_flip():
	for segment in [$Body, $Face, $Puff, $Item]:
		segment.offset.x = 0
		segment.offset.y = 0
		segment.flip_h = false

func play():
	var sync = null
	for segment in [$Face, $Body, $Puff, $Item]:
		if sync:
			segment.frame = sync[0]
			segment.frame_progress = sync[1]
		else:
			sync = [segment.frame, segment.frame_progress]
		
		segment.play()

func stop():
	for segment in [$Body, $Face, $Puff, $Item]:
		segment.stop()

func pause():
	for segment in [$Body, $Face, $Puff, $Item]:
		segment.pause()
