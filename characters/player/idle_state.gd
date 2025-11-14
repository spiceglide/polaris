extends State

var anim: AnimationPlayer
var item_sprite: AnimatedSprite2D

func enter():
	anim = parent.get_node("AnimationPlayer")
	item_sprite = parent.get_node("Sprite/Item")
	
	# Play idle animation (with or without holding)
	if parent.holding:
		item_sprite.animation = parent.holding.id
		anim.play("idle/" + parent.last_dir + "_hold")
	else:
		anim.play("idle/" + parent.last_dir)

func exit():
	pass

func update(_delta: float):
	$CommonState.handle_life(self)
	$CommonState.handle_holding(self, parent)
	$CommonState.handle_consumption(self, parent)
	$CommonState.handle_interaction(self, parent)

func physics_update(_delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if movement.length() > 0:
		var north: bool = movement.y < 0
		var east: bool = movement.x > 0
		var south: bool = movement.y > 0
		var west: bool = movement.x < 0
		
		var last_dir: String = ""
		if south:
			last_dir += "south"
		elif north:
			last_dir += "north"
		if east:
			last_dir += "east"
		elif west:
			last_dir += "west"
		
		parent.last_dir = last_dir
		state_transitioned.emit(self, "walk")
