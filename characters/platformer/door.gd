extends Node2D

@export var destination = self.position
var active_body = null

func _input(event: InputEvent) -> void:
	if not active_body:
		return
	
	if Input.is_action_pressed("move_down"):
		var camera = active_body.get_node("Camera2D")
		active_body.global_position = destination

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		active_body = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		active_body = null
