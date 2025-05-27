extends VBoxContainer

@export var side: String

func _process(delta: float) -> void:
	if side == "left":
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
	elif side == "right":
		$Hunger.value = PlayerData.hunger
		$Warmth.value = PlayerData.warmth
