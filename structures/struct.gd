extends Node2D

@export var title: String
@export var current_state: String = "default"

var data: Dictionary = {}

func _ready() -> void:
	$Interaction.connect("interaction", _on_interaction)

func change_state(new_state) -> bool:
	current_state = new_state
	$AnimatedSprite2D.animation = new_state
	return true

func interact():
	match title:
		"campfire":
			if not data.has("times_used"):
				data["times_used"] = 0
			data["times_used"] += 1
			
			if data["times_used"] > 5:
				change_state("extinguished")
			else:
				match current_state:
					"default":
						change_state("ignited")
					"ignited":
						change_state("default")
					"extinguished":
						pass

func _on_interaction():
	interact()
