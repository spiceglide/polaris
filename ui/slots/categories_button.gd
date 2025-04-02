extends Control

@export var category: String

func _ready() -> void:
	$ItemSprite.animation = category

func enable():
	$Sprite.modulate = Color(1, 1, 1)

func disable():
	$Sprite.modulate = Color(0.6, 0.6, 0.6)

func _on_button_pressed() -> void:
	CraftingData.set_category(category)
