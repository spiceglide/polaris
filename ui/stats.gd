extends VBoxContainer

@export var side: String

func _ready() -> void:
	reset()

func reset() -> void:
	if WorldData.get_game_mode() == "dream":
		match side:
			"left":
				$Thirst.visible = false
			"right":
				$Hunger.visible = false
				$Warmth.visible = false
	else:
		for stat in self.get_children():
			stat.visible = true

func _process(delta: float) -> void:
	match side:
		"left":
			$Health.value = PlayerData.health
			#$Thirst.value = PlayerData.thirst
			$Sanity.value = PlayerData.sanity
			
			# Stages of insanity
			if $Sanity.value < 25:
				$Sanity/Icon.animation = "lowest"
				$Sanity/Effect.animation = "lowest"
			elif $Sanity.value < 50:
				$Sanity/Icon.animation = "low"
				$Sanity/Effect.animation = "low"
			elif $Sanity.value < 75:
				$Sanity/Icon.animation = "high"
				$Sanity/Effect.animation = "high"
			else:
				$Sanity/Icon.animation = "highest"
				$Sanity/Effect.animation = "highest"
		"right":
			$Hunger.value = PlayerData.hunger
			$Warmth.value = PlayerData.warmth
