extends Control

@onready var row_scene: Resource = preload("res://ui/notifications/ItemMessage.tscn")

@export var autochatter: Array = []
@export var autochatter_frequency: Dictionary = {"interval": 5, "odds": 0.5}

func _ready() -> void:
	$Commentary/Autochatter.wait_time = autochatter_frequency["interval"]

func announce(text: String):
	$Commentary/Announcement.text = '"' + text + '"'
	$Commentary/AudioStreamPlayer2D.play()
	$Items.position.y -= $Commentary/Announcement.size.y * 2
	$Commentary/Timeout.start()

func announce_items(items: Array):
	for i in range(len(items)):
		var item = items[i]
		var scene = row_scene.instantiate()
		var label = scene.get_node("Label")
		var icon = scene.get_node("AnimatedSprite2D")
		
		label.text = tr("ITEM_" + item.to_upper() + "_NAME")
		icon.animation = item.to_lower()
		
		$Items.add_child(scene)
	
	$Items/Timeout.start()

func _on_items_timeout() -> void:
	for row in $Items.get_children():
		if row is HBoxContainer:
			row.queue_free()
	
	$Items.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)

func _on_commentary_timeout() -> void:
	$Items.size.y += $Commentary/Announcement.size.y * 2
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
