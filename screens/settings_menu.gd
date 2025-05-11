extends CanvasLayer

func _on_back_pressed() -> void:
	self.get_parent().focus("SettingsMenu")
