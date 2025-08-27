extends State

var anim: AnimationPlayer
var item_sprite: AnimatedSprite2D
var animal_sprite: AnimatedSprite2D
var stage: int = 0

func enter():
	stage = 0
	anim = parent.get_node("AnimationPlayer")
	item_sprite = parent.get_node("Sprite/Item")
	animal_sprite = parent.get_node("Sprite/Animal")
	
	# Select victim
	var animal = InventoryData.get_selected_item()
	if animal in ["frog", "hare"]:
		animal_sprite.animation = animal
	
	anim.play("action/kill_1")
	anim.queue("action/kill_2")

func exit():
	parent.last_dir = "south"
	animal_sprite.visible = false

func update(delta: float):
	# Select weapon
	var weapon = InventoryData.get_selected_item()
	if weapon in ["hatchet", "rock"]:
		stage = 1
		item_sprite.animation = weapon + "_kill"
	else:
		stage = 0
		item_sprite.animation = ""
	
	if Input.is_action_just_pressed("interact"):
		match stage:
			0:
				state_transitioned.emit(self, "idle")
			1:
				stage = 2
				anim.play("action/kill_3")

func physics_update(delta: float):
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "action/kill_3":
		return
	
	state_transitioned.emit(self, "idle")
