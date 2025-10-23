extends State

var anim: AnimationPlayer
var item_sprite: AnimatedSprite2D

func enter():
	anim = parent.get_node("AnimationPlayer")
	item_sprite = parent.get_node("Sprite/Item")

	# Play idle animation (with or without holding)
	var item = InventoryData.get_selected_item()
	var data = InventoryData.get_selected_item_data()
	
	var last_dir = parent.last_dir
	if "holdable" in data.get("tags", []):
		item_sprite.animation = item
		anim.play("idle/" + last_dir + "_hold")
	else:
		anim.play("idle/" + last_dir)

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
		# Determine direction
		var last_dir: String = "south"
		if movement.y != 0:
			last_dir = "north" if movement.y < 0 else "south"
		else:
			last_dir = "west" if movement.x < 0 else "east"
		parent.last_dir = last_dir

		state_transitioned.emit(self, "walk")
