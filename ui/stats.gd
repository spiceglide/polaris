extends VBoxContainer

@export var side: String

func _process(delta: float) -> void:
	if side == "left":
		$Health.value = PlayerData.health
		#$Thirst.value = PlayerData.thirst
		$Sanity.value = PlayerData.sanity
	elif side == "right":
		$Hunger.value = PlayerData.hunger
		$Warmth.value = PlayerData.warmth
