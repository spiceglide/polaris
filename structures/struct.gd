extends Node2D

@export var title: String
@export var current_state: String = "default"

var data: Dictionary = {}

func _ready() -> void:
	var interact_node = self.find_child("Interaction")
	print(interact_node)
	interact_node.connect("interaction", _on_interaction)

func change_state(new_state) -> bool:
	current_state = new_state
	
	if title == "well":
		$Sprite/Base.animation = new_state
		$Sprite/Top.animation = new_state
	else:
		$AnimatedSprite2D.animation = new_state
	return true

func interact():
	match title:
		"campfire":
			if not data.has("times_used"):
				data["times_used"] = 0
			data["times_used"] += 1
			
			if data["times_used"] > 6:
				change_state("extinguished")
			else:
				match current_state:
					"default":
						change_state("ignited")
						$Light.visible = true
					"ignited":
						change_state("default")
						$Light.visible = false
					"extinguished":
						pass
		"smallfire":
			if not data.has("times_used"):
				data["times_used"] = 0
			data["times_used"] += 1
			
			if data["times_used"] > 3:
				change_state("extinguished")
			else:
				match current_state:
					"default":
						change_state("ignited")
						$Light.visible = true
					"ignited":
						change_state("default")
						$Light.visible = false
					"extinguished":
						pass
		"well":
			if not data.has("times_used"):
				data["times_used"] = 0
			data["times_used"] += 1
			
			if data["times_used"] > 30:
				change_state("disrepair")
			else:
				match current_state:
					"default":
						change_state("active")
						PlayerData.state = PlayerData.State.Cranking
						PlayerData.set_position($Handle/CollisionShape2D.global_position)
						$Sprite/Top.play()
					"active":
						change_state("default")
					"disrepair":
						pass

func _on_interaction():
	interact()


func _on_animation_finished() -> void:
	PlayerData.state = PlayerData.State.Awake
