extends Control

var row_scene: Resource = load("res://ui/notifications/ItemMessage.tscn")

@export var timeout_enabled: bool = true
@export var autochatter: Array = []
@export var autochatter_frequency: Dictionary = {"interval": 5, "odds": 0.5}

func _ready() -> void:
	$Commentary/Autochatter.wait_time = autochatter_frequency["interval"]

func announce(text: String):
	if $Commentary/Announcement.text == "":
		$Items.position.y -= $Commentary/Announcement.size.y * 2
		
	$Commentary/Announcement.text = '"' + text + '"'
	$Commentary/AudioStreamPlayer2D.play()

	if timeout_enabled:
		$Commentary/Timeout.start()

func announce_items(items: Array):
	for i in range(len(items)):
		var item = items[i]
		var scene = row_scene.instantiate()
		var label = scene.get_node("Label")
		var icon = scene.get_node("AnimatedSprite2D")
		
		label.text = tr("ITEM_" + item.to_upper() + "_NAME")
		if icon.sprite_frames.has_animation(item.to_lower()):
			icon.animation = item.to_lower()
		else:
			icon.animation = "default"
		
		$Items.add_child(scene)
	
	if timeout_enabled:
		$Items/Timeout.start()

func clear_text():
	$Commentary/Announcement.text = ""

	for row in $Items.get_children():
		if row is HBoxContainer:
			row.queue_free()

func _on_items_timeout() -> void:
	for row in $Items.get_children():
		if row is HBoxContainer:
			row.queue_free()
	
	$Items.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)

func _on_commentary_timeout() -> void:
	$Items.position.y += $Commentary/Announcement.size.y * 2
	$Items.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	$Commentary/Announcement.text = ""

func _on_autochatter_timeout() -> void:
	if $Commentary/Announcement.text:
		return
	if len(autochatter) == 0:
		return
	
	if randf() < autochatter_frequency["odds"]:
		var chatter = autochatter.pick_random()
		announce(chatter)
