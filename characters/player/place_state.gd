extends State

var anim: AnimationPlayer

func enter():
	var last_dir = parent.last_dir
	
	anim = parent.get_node("AnimationPlayer")
	anim.play("place/" + last_dir)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not anim_name.begins_with("place/"):
		return
	
	parent.complete_structure()
	parent.placing = null
	InventoryData.use_selected_item()
	state_transitioned.emit(self, "idle")
