extends Label

func announce(text: String) -> void:
	self.text = text
	$Timer.start()

func _on_timer_timeout() -> void:
	self.text = ""
