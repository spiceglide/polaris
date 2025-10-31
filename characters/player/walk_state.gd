extends State

var direction: Vector2 = Vector2.ZERO
var anim: AnimationPlayer
var item_sprite: AnimatedSprite2D

func enter():
	direction = Vector2.ZERO
	anim = parent.get_node("AnimationPlayer")
	item_sprite = parent.get_node("Sprite/Item")
	
	if parent.holding:
		item_sprite.animation = parent.holding.id
		anim.play("walk/" + parent.last_dir + "_hold")
	else:
		anim.play("walk/" + parent.last_dir)

func exit():
	direction = Vector2.ZERO

func update(_delta: float):
	$CommonState.handle_life(self)
	$CommonState.handle_holding(self, parent)
	$CommonState.handle_consumption(self, parent)
	$CommonState.handle_interaction(self, parent)

func physics_update(_delta: float):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Speed multiplier
	var mult = 1
	if Input.is_action_pressed("run"):
		mult = PlayerData.multiplier
	
	# Process
	if direction.length() > 0:
		parent.velocity = direction.normalized() * PlayerData.speed * mult
		parent.move_and_slide()
		
		# Determine direction
		var last_dir: String = "south"
		if direction.y != 0:
			last_dir = "north" if direction.y < 0 else "south"
		else:
			last_dir = "west" if direction.x < 0 else "east"
		parent.last_dir = last_dir
		
		if parent.holding:
			item_sprite.animation = parent.holding.id
			anim.play("walk/" + last_dir + "_hold")
		else:
			anim.play("walk/" + last_dir)
	else:
		state_transitioned.emit(self, "idle")
