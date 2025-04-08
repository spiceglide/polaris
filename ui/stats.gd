extends VBoxContainer

func _process(delta: float) -> void:
	$Health.value = PlayerData.health
	$Hunger.value = PlayerData.hunger
	$Warmth.value = PlayerData.warmth
	$Sanity.value = PlayerData.sanity
