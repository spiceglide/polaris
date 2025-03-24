extends Control

enum Category {
	All,
	Fire,
	Tool,
	Vessel,
	Sanity
}

@export var category: Category

func _ready() -> void:
	match category:
		Category.All:
			$ItemSprite.animation = "all"
		Category.Fire:
			$ItemSprite.animation = "fire"
		Category.Tool:
			$ItemSprite.animation = "tool"
		Category.Vessel:
			$ItemSprite.animation = "vessel"
		Category.Sanity:
			$ItemSprite.animation = "sanity"
