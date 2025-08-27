extends State

var anim: AnimationPlayer

func enter():
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/pull")

func exit():
	var item = InventoryData.get_selected_item()
	if item in ["torch"]:
		var light = parent.get_node("Light")
		light.visible = true

func update(delta: float):
	pass

func physics_update(delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if movement.length() > 0:
		state_transitioned.emit(self, "walk")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "action/pull":
		return
	
	parent.last_dir = "south"
	state_transitioned.emit(self, "idle")
