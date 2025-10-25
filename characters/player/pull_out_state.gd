extends State

var anim: AnimationPlayer

func enter():
	anim = parent.get_node("AnimationPlayer")
	anim.play("action/pull")

func update(delta: float):
	pass

func physics_update(delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if movement.length() > 0:
		state_transitioned.emit(self, "walk")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "action/pull":
		return
	
	var item := InventoryData.get_selected_item()
	var data := InventoryData.get_item_data(item)
	var tags = data.get("tags", [])
	
	parent.holding = item
	parent.last_dir = "south"
	
	anim.play("idle/south_hold")
	
	if "light" in tags:
		var light = parent.get_node("Light")
		light.visible = true
	
	state_transitioned.emit(self, "idle")
