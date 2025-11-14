extends State

@export var animations: Array

func enter():
	var anim_player := parent.get_node("AnimationPlayer")
	anim_player.play("fixed")



func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	body.set_collision_layer_value(5, false)
	body.set_collision_mask_value(5, false)
	print("entered")

func _on_body_exited(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	body.set_collision_layer_value(5, true)
	body.set_collision_mask_value(5, true)
	print("exited")
