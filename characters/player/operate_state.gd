extends State

var anim: AnimationPlayer
var terminable: bool = false

func toggle_menu(state: bool):
	get_tree().call_group("station", "_toggle_menu", state)

func apply_recipe(state: bool):
	if (state == false) or (len(parent.interactable) == 0):
		get_tree().call_group("station", "_apply_station", "")
	else:
		var id = parent.interactable[0].get_structure_id()
		get_tree().call_group("station", "_apply_station", id)

func enter():
	terminable = false
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/think")
	
	apply_recipe(true)
	toggle_menu(true)

func exit():
	terminable = false
	apply_recipe(false)

func update(_delta: float):
	if Input.is_action_just_pressed("inventory"):
		state_transitioned.emit(self, "walk")

func physics_update(_delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if terminable and (movement.length() > 0):
		state_transitioned.emit(self, "walk")
		toggle_menu(false)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "action/think":
		return
	terminable = true
