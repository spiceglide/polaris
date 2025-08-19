extends State

var anim: AnimationPlayer
var item_sprite: AnimatedSprite2D
var animal_sprite: AnimatedSprite2D
var stage: int = 0

func enter():
	stage = 0
	anim = parent_body.get_node("AnimationPlayer")
	item_sprite = parent_body.get_node("Sprite/Item")
	animal_sprite = parent_body.get_node("Sprite/Animal")
	
	var animal = InventoryData.get_selected_item()
	if animal in ["frog", "hare"]:
		animal_sprite.animation = animal
	
	anim.play("action/kill_1")
	anim.queue("action/kill_2")

func exit():
	return

func update(delta: float):
	print(animal_sprite.animation)
	var weapon = InventoryData.get_selected_item()
	if weapon in ["hatchet", "rock"]:
		stage = 1
		item_sprite.animation = weapon + "_kill"
	else:
		stage = 0
		item_sprite.animation = ""
	
	if Input.is_action_just_pressed("use_item") and stage == 1:
		stage = 2
		anim.play("action/kill_3")

func physics_update(delta: float):
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "action/kill_3":
		return
	
	parent_body.last_dir = "south"
	state_transitioned.emit(self, "idle")
