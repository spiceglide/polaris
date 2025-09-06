extends CanvasLayer

@export var health: bool = true
@export var hunger: bool = true
@export var thirst: bool = true
@export var warmth: bool = true
@export var sanity: bool = true

func _ready() -> void:
	$StatsLeft/Health.visible = true if health else false
	$StatsLeft/Thirst.visible = true if thirst else false
	$StatsLeft/Sanity.visible = true if sanity else false
	$StatsRight/Hunger.visible = true if hunger else false
	$StatsRight/Warmth.visible = true if warmth else false

func _process(_delta: float) -> void:
	$StatsLeft/Health.value = PlayerData.health
	$StatsLeft/Thirst.value = PlayerData.thirst
	$StatsLeft/Sanity.value = PlayerData.sanity
	
	# Stages of insanity
	if $StatsLeft/Sanity.value < 25:
		$StatsLeft/Sanity/Icon.animation = "lowest"
		$StatsLeft/Sanity/Effect.animation = "lowest"
	elif $StatsLeft/Sanity.value < 50:
		$StatsLeft/Sanity/Icon.animation = "low"
		$StatsLeft/Sanity/Effect.animation = "low"
	elif $StatsLeft/Sanity.value < 75:
		$StatsLeft/Sanity/Icon.animation = "high"
		$StatsLeft/Sanity/Effect.animation = "high"
	else:
		$StatsLeft/Sanity/Icon.animation = "highest"
		$StatsLeft/Sanity/Effect.animation = "highest"

	$StatsRight/Hunger.value = PlayerData.hunger
	$StatsRight/Warmth.value = PlayerData.warmth
