extends Control

func _ready() -> void:
	$Sprite.animation = "hint"
	$Sprite.play()
	
	await get_tree().process_frame
	scale = Vector2(0.7, 0.7)
	
func _on_button_pressed() -> void:
	var event = InputEventAction.new()
	event.action = "inventory"
	event.pressed = true
	Input.parse_input_event(event)
