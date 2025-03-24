extends Control

enum Category {
	All,
	Fire,
	Tool,
	Vessel,
	Sanity
}

@export var category: Category
@export var anim: String = "type1"

func _ready() -> void:
	$Sprite.animation = anim
	
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
	
	$Sprite.play()
	$ItemSprite.play()
