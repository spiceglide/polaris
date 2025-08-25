extends CanvasLayer

func toggle_text(state: bool):
	$Dialog.visible = state
	print($Dialog.visible)

func _on_yes_pressed() -> void:
	get_tree().quit()

func _on_no_pressed() -> void:
	self.get_parent().focus("QuitMenu")
