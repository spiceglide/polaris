extends State

var anim: AnimationPlayer
var terminable: bool = false

func enter():
	terminable = false
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/eat_1")
	anim.queue("action/eat_2")

func exit():
	terminable = false

func update(_delta: float):
	if terminable and (Input.is_action_just_pressed("hotbar") or Input.is_action_just_pressed("inv_prev") or Input.is_action_just_pressed("inv_next")):
		state_transitioned.emit(self, "idle")

func physics_update(_delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if terminable and (movement.length() > 0):
		state_transitioned.emit(self, "walk")

func _on_animation_player_animation_changed(old_name: StringName, new_name: StringName) -> void:
	if [old_name, new_name] == [&"action/eat_1", &"action/eat_2"]:
		terminable = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "action/eat_2":
		return
	
	parent.last_dir = "south"
	InventoryData.use_selected_item()
	state_transitioned.emit(self, "idle")
